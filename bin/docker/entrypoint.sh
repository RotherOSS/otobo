#!/usr/bin/env bash

# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

# Note that in the docker image this file will be available as
# /opt/otobo_install/entrypoint.sh .

################################################################################
# Declare file scoped variables
################################################################################

otobo_next="/opt/otobo_install/otobo_next"
update_log="/opt/otobo/var/log/update.log"

################################################################################
# Declare functions
################################################################################

# does the initial copy to /opt/otobo
function handle_docker_firsttime() {

    if [ ! -d  $OTOBO_HOME ]; then
        # it is required that /opt/otobo is mounted
        print_error "the volume $OTOBO_HOME is not mounted" && exit 1
    elif [ ! "$(ls $OTOBO_HOME)" ]; then
        # first the simple case: there is no previous installation
        # use a simle 'ls' for checking dir content, hidden files like .bashrc are ignored
        copy_otobo_next
    fi

    # When /opt/otobo already exists then there is no automatic update.
    # The updating has to be triggered with the explicit commands 'copy_otobo_next' and 'do_update_tasks'.

    # we are done, docker_firstime has been handled
    # $otobo_next is not removed, it is kept for future reference
    # Note that docker_firsttime_handled is only available in the service web.
    mv $otobo_next/docker_firsttime $otobo_next/docker_firsttime_handled
}

# An easy way to start bash.
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

        # Do not try to start the Daemon when /opt/otobo is still being created.
        if [ -f ".copy_otobo_next_finished" ]; then
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

    # For production use the web server Gazelle, which is implemented in C.
    # The special loader Plack::Loader::SyncWithS3 is activated only when S3 is active. That loader module checks for updates in S3.
    s3_active=$(perl -I . -I Kernel/cpan-lib/ -MKernel::Config -E 'my $Conf = Kernel::Config->new(Level => q{Clear}); print $Conf->Get(q{Storage::S3::Active});')
    if [[ "$s3_active" -eq "1" ]]; then
        exec plackup --server Gazelle --env deployment --port 5000 -I /opt/otobo -I /opt/otobo/Kernel/cpan-lib --loader SyncWithS3  bin/psgi-bin/otobo.psgi
    else
        exec plackup --server Gazelle --env deployment --port 5000 bin/psgi-bin/otobo.psgi
    fi
}

# preserve added files in the previous
function copy_otobo_next() {

    # Copy files recursively.
    # Changed files are overwritten, new files are not deleted.
    # File attributes are preserved.
    # Copying $otobo_next/. makes it irrelevant whether $OTOBO_HOME already exists.
    cp --archive $otobo_next/. $OTOBO_HOME

    {
        date
        echo "Copied $otobo_next to $OTOBO_HOME"
        echo
    } >> $update_log

    # clean up
    rm -f $OTOBO_HOME/docker_firsttime
    rm -f $OTOBO_HOME/docker_firsttime_handled

    # Make sure that an initial config is available. But don't overwrite existing config.
    # Use the docker specific Config.pm.dist file.
    cp --no-clobber $OTOBO_HOME/Kernel/Config.pm.docker.dist $OTOBO_HOME/Kernel/Config.pm
    cp --no-clobber $OTOBO_HOME/Kernel/Config.pod.dist       $OTOBO_HOME/Kernel/Config.pod

    # Indicate the time when copy_otobo_next() was last called. This is used primarily
    # for the OTOBO daemon who needs to know that /opt/otobo has been copied completely.
    touch $OTOBO_HOME/.copy_otobo_next_finished
}

function do_update_tasks() {

    # reinstall package, rebuild config, purge cache
    # Not that this works only if OTOBO has been properly configured
    {
        echo "started do_update_tasks()"
        date
        ($OTOBO_HOME/bin/otobo.Console.pl Admin::Package::ReinstallAll 2>&1)
        ($OTOBO_HOME/bin/otobo.Console.pl Admin::Package::UpgradeAll 2>&1)
        ($OTOBO_HOME/bin/otobo.Console.pl Maint::Config::Rebuild 2>&1)
        ($OTOBO_HOME/bin/otobo.Console.pl Maint::Cache::Delete 2>&1)
        date
        echo "finished do_update_tasks()"
        echo
    } >> $update_log
}

print_error() {
    echo -e "\e[101m[ERROR]\e[0m $1"
}

################################################################################
# Do the work
################################################################################

# container should not be run as root
if [ ! -z "$UID" ] && [ $UID -eq 0 ]; then
    exit 1
fi

# now running as $OTOBO_USER

# print usage message when no param was passed
if [ "$1" = "" ]; then
    cat <<END_HELP
This script is meant to be used as a Docker entrypoint script.
Supported arguments are: 'daemon', 'web', 'copy_otobo_next', 'do_update_tasks'.
When no argument is passed, then this message is printed.
Any other argument list will be executed as a system command.
END_HELP

    exit 0
fi

# Start the OTOBO daemon
if [ "$1" = "daemon" ]; then

    # When /opt/otobo isn't a Docker volume we rirst check whether the container is started with a new image.
    # If /opt/otobo is a volume we assume that there is a web container who does this for us.
    if ! mountpoint -q "/opt/otobo"; then

        # There is no locking as we no other container can meddle with /opt/otobo.
        if [ -f "$otobo_next/docker_firsttime" ]; then
            handle_docker_firsttime
        fi
    fi

    # do some work
    start_and_check_daemon

    exit $?
fi

# Start the webserver
if [ "$1" = "web" ]; then

    # First check whether the container is started with a new image.
    # There is no locking as we assume that there aren't multiple containers trying to the same.
    if [ -f "$otobo_next/docker_firsttime" ]; then
        handle_docker_firsttime
    fi

    # start webserver
    exec_web
fi

# copy /opt/otobo_install/otobo_next without checking docker_firsttime
if [ "$1" = "copy_otobo_next" ]; then
    copy_otobo_next

    exit $?
fi

# update
if [ "$1" = "do_update_tasks" ]; then
    do_update_tasks

    exit $?
fi

# as a fallback execute the passed command
exec_whatever $@
