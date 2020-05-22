#!/bin/bash

# Start up OTOBO Daemon and the webserver
# Run a watchdog over the Daemon via Cron

# no arguments are handled

# start the Daemon and set up the Cron watchdog
mkdir var/tmp
./bin/Cron.sh start root
./bin/otobo.Daemon.pl start

# maintainance jobs
./bin/otobo.Console.pl Maint::Config::Rebuild
./bin/otobo.Console.pl Maint::Cache::Delete

plackup --server Gazelle --port 5000 bin/psgi-bin/otobo.psgi
