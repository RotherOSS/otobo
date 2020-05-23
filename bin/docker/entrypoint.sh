#!/usr/bin/env bash

# Start up OTOBO Daemon and the webserver
# Run a watchdog over the Daemon via Cron

# no command line arguments are handled

# start the Daemon and set up the Cron watchdog
# assume that we are in /opt/otobo
mkdir var/tmp
./bin/Cron.sh start root
perl ./bin/otobo.Daemon.pl start

# maintainance jobs
perl ./bin/otobo.Console.pl Maint::Config::Rebuild
perl ./bin/otobo.Console.pl Maint::Cache::Delete

plackup --server Gazelle --port 5000 bin/psgi-bin/otobo.psgi
