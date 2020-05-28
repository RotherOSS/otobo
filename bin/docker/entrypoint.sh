#!/usr/bin/env bash

# no command line arguments are handled

# Start up OTOBO Daemon and the webserver
# Run a watchdog over the Daemon via Cron

# assume that we are in /opt/otobo
mkdir -p var/tmp

# set up the cronjobs as they are declared in var/cron
./bin/Cron.sh start

# Start the Daemon.
# The Daemon will exit immediately when SecureMode = 0.
# But this is OK, as Cron will restart it and it will run when SecureMode = 1.
./bin/otobo.Daemon.pl start

# maintainance jobs
# TODO: decide whether it makes sense to run these jobs on startup
#perl ./bin/otobo.Console.pl Maint::Config::Rebuild
#perl ./bin/otobo.Console.pl Maint::Cache::Delete

# Start the webserver
plackup --server Gazelle -R Kernel,bin/psgi-bin/otobo.psgi --port 5000 bin/psgi-bin/otobo.psgi
