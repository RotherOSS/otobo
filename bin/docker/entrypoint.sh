#!/usr/bin/env bash

# Start up OTOBO Daemon and the webserver
# Run a watchdog over the Daemon via Cron

# no command line arguments are handled

# start the Daemon and set up the Cron watchdog
# assume that we are in /opt/otobo
# TODO: this might not work when the database is not yet created and configured
mkdir var/tmp
./bin/Cron.sh start
perl ./bin/otobo.Daemon.pl start

# maintainance jobs
# TODO: this might not work when the database is not yet created and configured
#perl ./bin/otobo.Console.pl Maint::Config::Rebuild
#perl ./bin/otobo.Console.pl Maint::Cache::Delete

plackup --server Gazelle --port 5000 bin/psgi-bin/otobo.psgi
