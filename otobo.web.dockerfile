# This is the build file for the OTOBO web docker image.
# The services OTOBO web and OTOBO daemon use the same image.
# There is also an extra build target otobo-web-kerberos that adds support for Kerberos.

# See also bin/docker/build_docker_images.sh
# See also https://docs.docker.com/docker-hub/builds/advanced/
# See also https://doc.otobo.org/manual/installation/10.1/en/content/installation-docker.html

# Use the latest maintainance release of the Perl 5.38.x series as the base.
#
# The Debian version is explicitly set to bookworm, that is Debian 12.
# This avoids a surprising change of the version of Debian when the image
# is rebuilt, especially when the image for a new release of OTOBO is built.
# Note that the minor version of Debian may change between builds.
#
# The individual build targets may add additional Debian or CPAN packages.
FROM perl:5.38-bookworm AS base

# First there is some initial setup that needs to be done by root.
USER root

# Install some required and optional Debian packages.
#
# For ODBC see https://blog.devart.com/installing-and-configuring-odbc-driver-on-linux.html
# For ODBC for SQLIte, for testing ODBC, see http://www.ch-werner.de/sqliteodbc/html/index.html
#
# The webserver needs to connect to MariaDB service using DBD::mysql. For that purpose
# 'default-mysql-client' is installed. This allows the building
# of the Perl module DBD::mysql. It also installs the command line program 'mysql'.
#
# Create /opt/otobo_install already here, in order to reduce the number of build layers.
# hadolint ignore=DL3008
#
# create the otobo user
#   --user-group            create group 'otobo' and add the user to the created group
#   --home-dir /opt/otobo   set $HOME of the user
#   --create-home           create /opt/otobo
#   --shell /bin/bash       set the login shell, not used here because otobo is system user
#   --comment 'OTOBO user'  complete name of the user
#
# Also create /opt/otobo_install and /opt/otobo
ENV OTOBO_USER=otobo
ENV OTOBO_GROUP=otobo
ENV OTOBO_HOME=/opt/otobo
RUN apt-get update\
 && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install\
 "ack"\
 "cron"\
 "default-mysql-client"\
 "graphviz"\
 "ldap-utils"\
 "less"\
 "nano"\
 "odbcinst1debian2" "libodbc1" "odbcinst" "unixodbc-dev" "unixodbc"\
 "freetds-bin" "freetds-common" "tdsodbc"\
 "postgresql-client"\
 "redis-tools"\
 "sqlite3" "libsqliteodbc"\
 "rsync"\
 "screen"\
 "telnet"\
 "tree"\
 "vim"\
 "chromium"\
 "chromium-sandbox"\
 "libqrencode-dev"\
 && useradd --user-group --home-dir $OTOBO_HOME --create-home --shell /bin/bash --comment 'OTOBO user' $OTOBO_USER\
 && install -d /opt/otobo_install\
 && install --group $OTOBO_GROUP --owner $OTOBO_USER -d $OTOBO_HOME

# We want an UTF-8 console
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Install CPAN distributions that are required by OTOBO into the local lib /opt/otobo_install/local.
# The Perl module installer 'cpanm' is already available via the base image.
#
# Note that the modules in /opt/otobo/Kernel/cpan-lib are not considered by cpanm.
# This hopefully reduces potential conflicts.
#
# carton install will create cpanfile.snapshot. Currently this file is only used for documentation.
#
# Clean up the .cpanm dir after the installation tasks as that dir is no longer needed
# and the unpacked Perl distributions sometimes have weird user and group IDs.
WORKDIR /opt/otobo_install
COPY cpanfile.docker cpanfile
ENV PERL5LIB="/opt/otobo_install/local/lib/perl5"
ENV PATH="/opt/otobo_install/local/bin:${PATH}"
RUN cpanm --local-lib local Carton\
 && PERL_CPANM_OPT="--local-lib /opt/otobo_install/local" carton install\
 && rm -rf "/root/.cpanm"

# Add some additional meta info to the image.
# This done at the end of the Dockerfile as changed labels and changed args invalidate the layer cache.
# The labels are compliant with https://github.com/opencontainers/image-spec/blob/master/annotations.md .
# For the standard build args passed by hub.docker.com see https://docs.docker.com/docker-hub/builds/advanced/.
# Titel is specific for the individual targets.
LABEL maintainer='Team OTOBO <dev@otobo.org>'
LABEL org.opencontainers.image.authors='Team OTOBO <dev@otobo.org>'
LABEL org.opencontainers.image.description='OTOBO is the new open source ticket system with strong functionality AND a great look'
LABEL org.opencontainers.image.documentation='https://otobo.org'
LABEL org.opencontainers.image.licenses='GNU General Public License v3.0 or later'
LABEL org.opencontainers.image.url='https://github.com/RotherOSS/otobo'
LABEL org.opencontainers.image.vendor='Rother OSS GmbH'

# Tell the web application and bin/otobo.SetPermissions.pl that it runs in a container.
# Note that this setting is essential for a correct migration from OTRS 6.
ENV OTOBO_RUNS_UNDER_DOCKER=1

# the entrypoint is not in the volume
ENTRYPOINT ["/opt/otobo_install/entrypoint.sh"]

# The regular build target, without Kerberos
FROM base AS otobo-web

# First there is some initial setup that needs to be done by root.
USER root

# No further Debian or CPAN packages are needed,
# so we only need to do the cleanup
RUN rm -rf /var/lib/apt/lists/*

# Copy the OTOBO installation to /opt/otobo_install/otobo_next and use it as the working dir.
# The files that are set up in .dockerignore. This means that a potentially existing Kernel/Config.pm
# won't be copied. Instead Kernel/Config.pm.docker.dist will be copied to Kernel/Config.pm in entrypoint.sh.
COPY --chown=$OTOBO_USER:$OTOBO_GROUP . /opt/otobo_install/otobo_next
WORKDIR /opt/otobo_install/otobo_next

# In a running installation additional Perl modules from CPAN might be needed. These be installed
# in the directory /opt/otobo/local. This directory is located in the volume /opt/otobo and therefore
# survives updates of the Docker image.
# /opt/otobo/local must be prepolulated with architecture and version dependent subdirs. These subdirs
# are added to @INC when a Perl process starts up.
RUN perl -Mlocal::lib=local
ENV PERL5LIB="/opt/otobo/local/lib/perl5:${PERL5LIB}"
ENV PATH="/opt/otobo/local/bin:${PATH}"

# Make sure that /opt/otobo exists and is writable by $OTOBO_USER.
# set up entrypoint.sh and docker_firsttime
# Finally set permissions. Explicitly pass --runs-under-docker as
# $ENV{OTOBO_RUNS_UNDER_DOCKER} is not yet set.
RUN install --owner $OTOBO_USER --group $OTOBO_GROUP -D bin/docker/entrypoint.sh /opt/otobo_install/entrypoint.sh\
 && install --owner $OTOBO_USER --group $OTOBO_GROUP /dev/null docker_firsttime\
 && perl bin/otobo.SetPermissions.pl --runs-under-docker

# perform build steps that can be done as the user otobo.
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

# Activate SysConfig settings that should override that defaults when running in Docker.
RUN cp Kernel/Config/Files/XML/DockerConfig.xml.dist Kernel/Config/Files/XML/DockerConfig.xml

# Create dirs.
# Enable bash completion.
# Add a .vimrc.
# make Docker image identifyable via the files git-(repo|branch|commit).txt
# Create ARCHIVE with hashes of the files in the workdir
ARG GIT_REPO=unspecified
ARG GIT_BRANCH=unspecified
ARG GIT_COMMIT=unspecified
RUN install -d var/stats var/packages var/article var/tmp \
    && (echo ". ~/.bash_completion" >> .bash_aliases ) \
    && install -m u=rw,g=r,o=r scripts/vim/.vimrc .vimrc \
    && (echo $GIT_REPO   > git-repo.txt) \
    && (echo $GIT_BRANCH > git-branch.txt) \
    && (echo $GIT_COMMIT > git-commit.txt) \
    && bin/otobo.CheckSum.pl -a create

# Up to now we have prepared /opt/otobo_install/otobo_next.
# Merging /opt/otobo_install/otobo_next and /opt/otobo is left to /opt/otobo_install/entrypoint.sh.
# Note that for supporting the command 'cron' we need to start as root.
# For all other commands entrypoint.sh switches to the user otobo.
WORKDIR $OTOBO_HOME

# Titel is specific for the build target
LABEL org.opencontainers.image.title='OTOBO'

# These labels change with every build
ARG BUILD_DATE=unspecified
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.revision=$GIT_COMMIT
LABEL org.opencontainers.image.source=$GIT_REPO
ARG DOCKER_TAG=unspecified
LABEL org.opencontainers.image.version=$DOCKER_TAG

# This Dockerfile also provides for building images with additional support for Kerberos.
# This image will be built when --target=otobo-web-kerberos is specified in the 'docker build' command.
FROM base AS otobo-web-kerberos

# First there is some initial setup that needs to be done by root.
USER root

# install Kerberos related Debian packages
RUN apt-get update\
 && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install\
 "krb5-user"\
 "libpam-krb5"\
 "libpam-ccreds"\
 "krb5-multidev"\
 "libkrb5-dev"\
 && rm -rf /var/lib/apt/lists/*

# append extra modules needed for Kerberos
# Clean up the .cpanm dir after the installation tasks as that dir is no longer needed
# and the unpacked Perl distributions sometimes have weird user and group IDs.
WORKDIR /opt/otobo_install
RUN cpanm --local-lib local Authen::Krb5::Simple\
 && cpanm --local-lib local LWP::Authen::Negotiate\
 && rm -rf "/root/.cpanm"

# perform build steps that can be done as the user otobo.
USER $OTOBO_USER

# skipping /opt/otobo_install/local
COPY --from=otobo-web\
 /opt/otobo_install/entrypoint.sh\
 /opt/otobo_install
COPY --from=otobo-web --chown=$OTOBO_USER:$OTOBO_GROUP\
 /opt/otobo_install/otobo_next\
 /opt/otobo_install/otobo_next

WORKDIR $OTOBO_HOME

# Titel is specific for the build target
LABEL org.opencontainers.image.title='OTOBO Kerberos'

# These labels change with every build
ARG BUILD_DATE=unspecified
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.revision=$GIT_COMMIT
LABEL org.opencontainers.image.source=$GIT_REPO
ARG DOCKER_TAG=unspecified
LABEL org.opencontainers.image.version=$DOCKER_TAG
