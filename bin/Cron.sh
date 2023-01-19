#!/bin/sh
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

CURRENTUSER=`whoami`
CRON_USER="$2"

# check if a common user try to use -u
if test -n "$CRON_USER"; then
    if test $CURRENTUSER != root; then
        echo "Run this script just as OTOBO user! Or use 'Cron.sh {start|stop|restart} OTOBO_USER' as root!"
        exit 5
    fi
fi

# check if the cron user is specified
if test -z "$CRON_USER"; then
    if test $CURRENTUSER = root; then
        echo "Run this script just as OTOBO user! Or use 'Cron.sh {start|stop|restart} OTOBO_USER' as root!"
        exit 5
    fi
fi

# find otobo root
cd "`dirname $0`/../"
OTOBO_HOME="`pwd`"

#OTOBO_ROOT=/opt/otobo
if test -e $OTOBO_HOME/var/cron; then
    OTOBO_ROOT=$OTOBO_HOME
else
    echo "No cronjobs in $OTOBO_HOME/var/cron found!";
    echo " * Check the \$HOME (/etc/passwd) of the OTOBO user. It must be the root dir of your OTOBO system (e. g. /opt/otobo). ";
    exit 5;
fi

CRON_DIR=$OTOBO_ROOT/var/cron
CRON_TMP_FILE=$OTOBO_ROOT/var/tmp/otobo-cron-tmp.$$

#
# main part
#
case "$1" in
    # ------------------------------------------------------
    # start
    # ------------------------------------------------------
    start)
        # add -u to cron user if user exists
        if test -n "$CRON_USER"; then
            CRON_USER=" -u $CRON_USER"
        fi

        if mkdir -p $CRON_DIR; cd $CRON_DIR && ls -d * | grep -Ev "(\.(dist|rpm|bak|backup|custom_backup|save|swp)|\~)$" | xargs cat > $CRON_TMP_FILE && crontab $CRON_USER $CRON_TMP_FILE; then

            rm -rf $CRON_TMP_FILE
            echo "(using $OTOBO_ROOT) done";
            exit 0;
        else
            echo "failed";
            exit 1;
        fi
    ;;
    # ------------------------------------------------------
    # stop
    # ------------------------------------------------------
    stop)
        # add -u to cron user if user exists
        if test -n "$CRON_USER"; then
            CRON_USER=" -u $CRON_USER"
        fi

        if crontab $CRON_USER -r ; then
            echo "done";
            exit 0;
        else
            echo "failed";
            exit 1;
        fi
    ;;
    # ------------------------------------------------------
    # restart
    # ------------------------------------------------------
    restart)
        $0 stop "$CRON_USER"
        $0 start "$CRON_USER"
    ;;
    # ------------------------------------------------------
    # Usage
    # ------------------------------------------------------
    *)
    cat - <<HELP

Manage OTOBO cron jobs.

Usage:
 Cron.sh [action]

Arguments:
 [action]                      - 'start', 'stop' or 'restart' - activate or deactivate OTOBO cron jobs.
HELP

    exit 1
esac
