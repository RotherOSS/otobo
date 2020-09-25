#!/usr/bin/env bash

# Note that in the docker image this file will be available as
# /opt/otobo_install/entrypoint.sh .

################################################################################
# Declare file scoped variables
################################################################################

otobo_next="/opt/otobo_install/otobo_next"
upgrade_log="/opt/otobo/var/log/upgrade.log"

################################################################################
# Declare functions
################################################################################

# does a version check before upgrading
function handle_docker_firsttime() {

    if [ ! -d  $OTOBO_HOME ]; then
        # it is required that /opt/otobo is mounted
        print_error "the volume $OTOBO_HOME is not mounted" && exit 1
    elif [ ! "$(ls $OTOBO_HOME)" ]; then
        # first the simple case: there is no previous installation
        # use a simle 'ls' for checking dir content, hidden files like .bashrc are ignored
        upgrade_patchlevel_release
    else
        if [ "$(compare_versions "$otobo_next/RELEASE" "$OTOBO_HOME/RELEASE")" = "1" ]; then
            upgrade_patchlevel_release
            reinstall_all
        fi
    fi

    # we are done, docker_firstime has been handled
    # $otobo_next is not removed, it is kept for future reference
    # Note that docker_firsttime_handled is only available in otobo_web_1
    mv $otobo_next/docker_firsttime $otobo_next/docker_firsttime_handled
}

# An easy way to start bash.
# Or do upgrades.
# Or list files.
function exec_whatever() {
    exec $@
}

# Every 2 minutes try to start, or restart, the OTOBO Daemon.
# The Daemon will exit immediately when SecureMode = 0.
# But this is OK, as Cron will restart it and it will run when SecureMode = 1.
# Also gracefully handle the case when /opt/otobo is not populated yet.
# The watch command will be run in the forground.
function start_and_check_daemon() {

    # Docker is stopping containers by sending a SIGTERM signal to the PID=1 process.
    # As a fallback it sends SIGKILL after waiting 10s.
    # In the otobo_daemon_1 case the PID=1 process is this script.
    # Catch the SIGTERM signal and stop the child processes.
    # See also https://hynek.me/articles/docker-signals/.
    trap stop_daemon SIGTERM

    sleep_pid=
    while true; do
        if [ -f "bin/otobo.Daemon.pl" ]; then
            bin/otobo.Daemon.pl start
        fi
        # the '&' activates the builtin job control system
        # remember the PID of sleep, so that the process can be terminated in stop_daemon()
        sleep 120 & sleep_pid=$!

        # wait until the sleep exits or until a signal arrives,
        # which means that the stop_daemon() can run without having to wait for the sleep command
        wait $sleep_pid
        sleep_pid=
    done
}

# clean up the OTOBO daemon process
function stop_daemon() {
    if [ -f "bin/otobo.Daemon.pl" ]; then
        bin/otobo.Daemon.pl stop
        [[ $sleep_pid ]] && kill "$sleep_pid"
    fi

    # claim that everything is fine
    exit 0
}

# Start the webserver
function exec_web() {

    # For development omit the --env option, thus setting PLACK_ENV to its default value 'development'.
    # This enables additional middlewares that are useful during development.
    # For development also enable the -R option. This watches for changes in the modules and the config files.
    # otobo.psgi is watched implicitly.
    #   exec plackup --server Gazelle -R Kernel --port 5000 bin/psgi-bin/otobo.psgi

    # For debugging reload the complete application for each request by passing -L Shotgun
    #   exec plackup -L Shotgun --port 5000 bin/psgi-bin/otobo.psgi

    # For production use Gazelle, which is implemented in C
    exec plackup --server Gazelle --env deployment --port 5000 bin/psgi-bin/otobo.psgi
}

# preserve added files in the previous
function upgrade_patchlevel_release() {
    # TODO: maybe create a backup of /opt/otobo, in case somebody did change important files

    # Copy files recursively.
    # Changed files are overwritten, new files are not deleted.
    # File attributes are preserved.
    # Copying $otobo_next/. makes it irrelevant whether $OTOBO_HOME already exists.
    cp --archive $otobo_next/. $OTOBO_HOME

    {
        date
        echo "Copied $otobo_next to $OTOBO_HOME"
        echo
    } >> $upgrade_log

    # clean up
    rm -f $OTOBO_HOME/docker_firsttime
    rm -f $OTOBO_HOME/docker_firsttime_handled

    # Use the docker specific Config.pm.dist file.
    cp --no-clobber $OTOBO_HOME/Kernel/Config.pm.docker.dist $OTOBO_HOME/Kernel/Config.pm
    # Config.pod might have been adapted too, dont overwrite it
    cp --no-clobber $OTOBO_HOME/Kernel/Config.pod.dist       $OTOBO_HOME/Kernel/Config.pod
}

#function reinstall_all() {
#
#    # reinstall package
#    # Not that this works only if OTOBO has been properly configured
#    {
#        date
#        ($OTOBO_HOME/bin/otobo.Console.pl Admin::Package::ReinstallAll 2>&1)
#        echo
#    } >> $upgrade_log
#}

print_error() {
    echo -e "\e[101m[ERROR]\e[0m $1"
}

extract_version_from_release_file () {
    local release_file="$1"

    local current_version="$(cat $release_file | grep VERSION | cut -d'=' -f2)"

    echo $current_version
}

# prints logical output
# empty strings in questionable cases
# -1 if $1 less the $2
# 0 if $1 equals $2
# 1 if $1 greater $2
# The comparison is aware of the version semantics.
compare_versions () {
    local first_version="$(extract_version_from_release_file $1)"
    local second_version="$(extract_version_from_release_file $2)"

    # refuse to compare versions like 10.0.x.
    # This indicates development and the developer must decide herself.
    # upgrade can be forced with the command 'upgrade_patchlevel_release'
    [[ "$first_version"  =~ [^0-9.] ]] && echo "" && return 1
    [[ "$second_version" =~ [^0-9.] ]] && echo "" && return 2

    local lower_version=$(echo -e "$first_version\n$second_version" | sed '/^$/d' | sort --version-sort | head -1)
    [[ "$first_version" = "$lower_version" ]] && echo "-1" && return 0

    echo "1" && return 0

    return 3
}

################################################################################
# Do the work
################################################################################

# container should not be run as root
if [ ! -z "$UID" ] && [ $UID -eq 0 ]; then
    exit 1
fi

# now running as $OTOBO_USER

# Run the OTOBO Daemon the webserver
if [ "$1" = "daemon" ]; then
    start_and_check_daemon
    exit $?
fi

# Start the webserver
if [ "$1" = "web" ]; then
    # first check whether the container is started with a new image
    if [ -f "$otobo_next/docker_firsttime" ]; then
        handle_docker_firsttime
    fi

    # start webserver
    exec_web
fi

# copy otobo_next without checking docker_firsttime or RELEASE
# useful during development
if [ "$1" = "upgrade" ]; then
    upgrade_patchlevel_release
    exit $?
fi

#if [ "$1" = "upgrade_reinstall" ]; then
#    upgrade_patchlevel_release
#    reinstall_all
#    exit $?
#fi

# as a fallback execute the passed command
exec_whatever $@
