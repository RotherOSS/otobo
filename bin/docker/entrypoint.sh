#!/usr/bin/env bash

# no command line arguments are handled

# Start up OTOBO Daemon and the webserver
# Run a watchdog over the Daemon via Cron

# assume that we are in /opt/otobo
mkdir -p var/tmp

# set up the cronjobs as they are declared in var/cron
./bin/Cron.sh start
perl ./bin/otobo.Daemon.pl start

# maintainance jobs
# TODO: this might not work when the database is not yet created and configured
#perl ./bin/otobo.Console.pl Maint::Config::Rebuild
#perl ./bin/otobo.Console.pl Maint::Cache::Delete

plackup --server Gazelle -R Kernel,bin/psgi-bin/otobo.psgi --port 5000 bin/psgi-bin/otobo.psgi
