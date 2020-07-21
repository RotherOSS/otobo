#!/usr/bin/env bash

# root handles 'cron' and defers 'web' to the OTOBO user
# Also check whether $UID is set, as 'exec su user ...' apparently does not set $UID
if [ ! -z "$UID" ] && [ $UID -eq 0 ]; then
    if [ "$1" = "cron" ]; then
        # Start the OTOBO Daemon.
        # The Daemon will exit immediately when SecureMode = 0.
        # But this is OK, as Cron will restart it and it will run when SecureMode = 1.
        su -c "./bin/otobo.Daemon.pl start" "$OTOBO_USER"

        # Run a watchdog over the Daemon via Cron
        # run cron in the foreground
        exec cron -f
        # nothing will be executed beyond that line,
        # because exec replaces running process with the new one
    fi

    # everything else is run as otobo
    exec su "$OTOBO_USER" "$0" -- "$@"
    # nothing will be executed beyond that line,
    # because exec replaces running process with the new one
fi

if [ "$1" = "web" ]; then
    # maintainance jobs
    # TODO: decide whether it makes sense to run these jobs on startup
    #perl ./bin/otobo.Console.pl Maint::Config::Rebuild
    #perl ./bin/otobo.Console.pl Maint::Cache::Delete

    # Start the webserver
    #
    #   For development omit the --env option, thus setting PLACK_ENV to its default value 'development'.
    #   This enables additional middlewares that are useful durching development.
    #   For development also enable the -R option.
    #   This watches for changes in the modules and the config files and otobo.psgi is watched implicitly
    #     plackup --server Gazelle -R Kernel --port 5000 bin/psgi-bin/otobo.psgi
    #
    #   For debugging reload the complete application for each request
    #     plackup -L Shotgun --port 5000 bin/psgi-bin/otobo.psgi
    plackup --server Gazelle --env deployment --port 5000 bin/psgi-bin/otobo.psgi

else
    echo "Unknown option $1. Exiting."

    exit -1
fi
