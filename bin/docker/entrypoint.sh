#!/usr/bin/env bash

# Note that in the docker image this file will be located in /var/otobo.

################################################################################
# Declare file scoped variables
################################################################################

otobo_next="/var/otobo/otobo_next"

################################################################################
# Declare functions
################################################################################

# does a version check before upgrading
function handle_docker_firsttime() {

    if [ ! -d  $OTOBO_HOME ]; then
        # it is required that /opt/otobo is mounted
        print_error "the volume $OTOBO_HOME is not mounted" && exit 1
    elif [ ! "$(ls -A $OTOBO_HOME)" ]; then
        # first the simple case: there is no previous installation
        cp -r "$otobo_next"/* $OTOBO_HOME
        # Use the docker specific Config.pm.dist file.
        cp --no-clobber $OTOBO_HOME/Kernel/Config.pm.docker.dist $OTOBO_HOME/Kernel/Config.pm
        # Config.pod might have been adapted too, dont overwrite it
        cp --no-clobber $OTOBO_HOME/Kernel/Config.pod.dist       $OTOBO_HOME/Kernel/Config.pod
    else
        if [ "$(compare_versions "$otobo_next/RELEASE" "$OTOBO_HOME/RELEASE")" = "1" ]; then
            upgrade_patchlevel_release
        fi
    fi

    # we are done, docker_firstime has been handled
    mv $otobo_next/docker_firsttime $otobo_next/docker_firsttime_handled

    # TODO: maybe clean up $otobo_next
}

# An easy way to start bash.
# Or do upgrades.
# Or list files.
function exec_whatever() {
    exec "$@"
}

# First try to start the OTOBO Daemon and the continue with cron
function exec_cron() {

    # Start the OTOBO Daemon.
    # The Daemon will exit immediately when SecureMode = 0.
    # But this is OK, as Cron will restart it and it will run when SecureMode = 1.
    # Also gracefully handle the case when /opt/otobo is not populated yet.
    if [ -f "./bin/otobo.Daemon.pl" ]; then
        su -c "./bin/otobo.Daemon.pl start" "$OTOBO_USER"
    fi

    # Run a watchdog over the Daemon via Cron
    # run cron in the foreground
    exec cron -f
    # nothing will be executed beyond this line,
    # because exec replaces running process with the new one
}

# Start the webserver
function exec_web() {

    # maintainance jobs
    # TODO: decide whether it makes sense to run these jobs on startup or on upgrade
    #perl ./bin/otobo.Console.pl Maint::Config::Rebuild
    #perl ./bin/otobo.Console.pl Maint::Cache::Delete

    #   For development omit the --env option, thus setting PLACK_ENV to its default value 'development'.
    #   This enables additional middlewares that are useful durching development.
    #   For development also enable the -R option.
    #   This watches for changes in the modules and the config files and otobo.psgi is watched implicitly
    #     plackup --server Gazelle -R Kernel --port 5000 bin/psgi-bin/otobo.psgi
    #
    #   For debugging reload the complete application for each request
    #     plackup -L Shotgun --port 5000 bin/psgi-bin/otobo.psgi
    exec plackup --server Gazelle --env deployment --port 5000 bin/psgi-bin/otobo.psgi
}

# preserve added files in the previous
function upgrade_patchlevel_release() {
    # TODO: maybe backup /opt/otobo, in case somebody did change important files
    # for now we only copy files
    # Changed files are overwritten, new files are not deleted
    cp --recursive $otobo_next/* $OTOBO_HOME
    rm $OTOBO_HOME/docker_firsttime
    cp --no-clobber $OTOBO_HOME/Kernel/Config.pm.docker.dist $OTOBO_HOME/Kernel/Config.pm

    # reinstall package
    # Not that this works only if OTOBO has been properly configured
    $OTOBO_HOME/bin/otobo.Console.pl Admin::Package::ReinstallAll >> /var/otobo/upgrade.log 2>&1
}

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

# root handles 'cron' and defers everything else to the OTOBO user
# Also check whether $UID is set, as 'exec su user ...' apparently does not set $UID
if [ ! -z "$UID" ] && [ $UID -eq 0 ]; then
    if [ "$1" = "cron" ]; then
        exec_cron
    fi

    # everything else is run as otobo
    exec su "$OTOBO_USER" "$0" -- "$@"
    # nothing will be executed beyond that line,
    # because exec replaces running process with the new one
fi

# now running as $OTOBO_USER

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
if [ "$1" = "upgrade_patchlevel_release" ]; then
    upgrade_patchlevel_release
    exit $?
fi


# as a fallback execute the passed command
exec_whatever
