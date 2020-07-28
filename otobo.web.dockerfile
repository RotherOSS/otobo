# This is the build file for the OTOBO web docker image.
# See also README_DOCKER.md.

# use the latest Perl on Debian 10 (buster). As of 2020-07-02.
# cpanm is already installed
FROM perl:5.32.0-buster

USER root

# install some required and optional Debian packages
# For ODBC see https://blog.devart.com/installing-and-configuring-odbc-driver-on-linux.html
# For ODBC for SQLIte, for testing ODBC, see http://www.ch-werner.de/sqliteodbc/html/index.html
# TODO: oracle client
# TODO: LDAP
RUN packages=$( echo \
        "tree ack vim nano screen" \
        "default-mysql-client" \
        "postgresql-client" \
        "odbcinst1debian2 libodbc1 odbcinst unixodbc-dev unixodbc" \
        "sqlite libsqliteodbc" \
        "cron" \
    ) \
    && apt-get update \
    && apt-get -y --no-install-recommends install $packages \
    && rm -rf /var/lib/apt/lists/*

# We want an UTF-8 console
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# A minimal copy so that the Docker cache is not busted
COPY cpanfile ./cpanfile

# Found no easy way to install with --force in the cpanfile. Therefore install
# the modules with ignorable test failures with the option --force.
# Note that the modules in /opt/otobo/Kernel/cpan-lib are not considered by cpanm.
# This hopefully reduces potential conflicts.
RUN cpanm --force XMLRPC::Transport::HTTP Net::Server Linux::Inotify2
RUN cpanm \
    --with-feature=db:mysql \
    --with-feature=db:postgresql \
    --with-feature=db:odbc \
    --with-feature=db:sqlite \
    --with-feature=plack \
    --with-feature=devel:dbviewer \
    --with-feature=div:bcrypt \
    --with-feature=performance:json \
    --with-feature=mail:imap \
    --with-feature=mail:sasl \
    --with-feature=div:ldap \
    --with-feature=performance:csv \
    --with-feature=div:xslt \
    --with-feature=performance:redis \
    --with-feature=devel:test \
    --installdeps .

# create the otobo user
#   --user-group            create group 'otobo' and add the user to the created group
#   --home-dir /opt/otobo   set $HOME of the user
#   --create-home           create /opt/otobo
#   --shell /bin/bash       set the login shell, not used here because otobo is system user
#   --comment 'OTOBO user'  complete name of the user
ENV OTOBO_USER  otobo
ENV OTOBO_GROUP otobo
ENV OTOBO_HOME  /opt/otobo
RUN useradd --user-group --home-dir $OTOBO_HOME --create-home --shell /bin/bash --comment 'OTOBO user' $OTOBO_USER

# copy the OTOBO installation to /opt/otobo and use it as the working dir
# skip the files set up in .dockerignore
ARG OTOBO_INSTALL=/opt/otobo_install
COPY --chown=$OTOBO_USER:$OTOBO_GROUP . $OTOBO_INSTALL/otobo_next
WORKDIR $OTOBO_INSTALL/otobo_next

# uncomment these steps when strange behavior must be investigated
#RUN echo "'$OTOBO_HOME'"
#RUN whoami
#RUN pwd
#RUN uname -a
#RUN ls -a
#RUN tree Kernel
#RUN false

# Some initial setup that needs to be done by root.
# Make sure that /opt/otobo exists and is writable by $OTOBO_USER.
# set up entrypoint, upgrade.log, docker_firsttime
# Finally set permissions.
RUN install --group $OTOBO_GROUP --owner $OTOBO_USER -d $OTOBO_HOME \
    && install --owner $OTOBO_USER --group $OTOBO_GROUP -D bin/docker/entrypoint.sh $OTOBO_INSTALL/entrypoint.sh \
    && install --owner $OTOBO_USER --group $OTOBO_GROUP /dev/null $OTOBO_INSTALL/upgrade.log \
    && install --owner $OTOBO_USER --group $OTOBO_GROUP /dev/null docker_firsttime \
    && perl bin/docker/set_permissions.pl

# start the webserver
# start the OTOBO daemon
# start the Cron watchdog
# Tell the webapplication that it runs in a container.
# The entrypoint takes one command: 'web' or 'cron', web switches to OTOBO_USER
USER $OTOBO_USER

# More setup that can be done by the user otobo

# Under Docker the Elasticsearch Daemon is running on the host 'elastic' instead of '127.0.0.1'.
# The webservice configuration is in a YAML file and it is not obvious how
# to change settings for webservices.
# So we take the easy was out and do the change directly in the XML file,
# before installer.pl has run.
# Doing this already in the initial database insert allows installer.pl
# to pick up the changed host and to check whether Elasticsearch is available.
RUN perl -p -i.orig -e "s{Host: http://localhost:9200}{Host: http://elastic:9200}" scripts/database/otobo-initial_insert.xml

# Create dirs.
# Enable bash completion.
# Add a .vimrc.
# Config.pm.docker.dist will be copied to Config.pm in entrypoint.sh,
# unless Config.pm already exists
RUN install -d var/stats var/packages var/article var/tmp \
    && (echo ". ~/.bash_completion" >> .bash_aliases ) \
    && install scripts/vim/.vimrc .vimrc

# Activate the .dist files for cron.
# Generate and install the crontab for the user $OTOBO_USER.
# Explicitly set PATH as the required perl is located in /usr/local/bin/perl.
RUN ( cd var/cron && for foo in *.dist; do cp $foo `basename $foo .dist`; done ) \
    &&  { \
            echo "# File added by Dockerfile" \
            && echo "# Let '/usr/bin/env perl' find perl in /usr/local/bin" \
            && echo "PATH=/usr/local/bin:/usr/bin:/bin" \
	    } >> var/cron/aab_path \
    && ./bin/Cron.sh start

# Create ARCHIVE as the last step
RUN bin/otobo.CheckSum.pl -a create

# Up to now we have prepared /opt/otobo_install/otobo_next.
# Merging /opt/otobo_install/otobo_next and /opt/otobo is left to /opt/otobo_install/entrypoint.sh.
# Note that for supporting 'cron' we need to start as root.
USER root
WORKDIR $OTOBO_HOME
ENV OTOBO_RUNS_UNDER_DOCKER 1

# for some reason $OTOBO_INSTALL can't be used here
ENTRYPOINT ["/opt/otobo_install/entrypoint.sh"]
