# This is the build file for the OTOBO Elasticsearch docker image.
# See also README_DOCKER.md.

# Use 7.8.0, because latest flag is not available
# This image is based on CentOS 7. The User is root.
FROM docker.elastic.co/elasticsearch/elasticsearch:7.9.2

# install system tools
# hadolint ignore=DL3008
RUN yum install -y\
 "less"\
 "nano"\
 "tree"\
 "vim"

# Install important plugins
RUN bin/elasticsearch-plugin install --batch ingest-attachment
RUN bin/elasticsearch-plugin install --batch analysis-icu

# We want an UTF-8 console
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Add some additional meta info to the image.
# This done at the end of the Dockerfile as changed labels and changed args invalidate the layer cache.
# The labels are compliant with https://github.com/opencontainers/image-spec/blob/master/annotations.md .
# For the standard build args passed by hub.docker.com see https://docs.docker.com/docker-hub/builds/advanced/.
LABEL maintainer='Team OTOBO <dev@otobo.org>'
LABEL org.opencontainers.image.authors='Team OTOBO <dev@otobo.org>'
LABEL org.opencontainers.image.description='OTOBO is the new open source ticket system with strong functionality AND a great look'
LABEL org.opencontainers.image.documentation='https://otobo.org'
LABEL org.opencontainers.image.licenses='GNU General Public License v3.0 or later'
LABEL org.opencontainers.image.title='OTOBO elasticsearch'
LABEL org.opencontainers.image.url=https://github.com/RotherOSS/otobo
LABEL org.opencontainers.image.vendor='Rother OSS GmbH'
ARG BUILD_DATE=unspecified
LABEL org.opencontainers.image.created=$BUILD_DATE
ARG GIT_COMMIT=unspecified
LABEL org.opencontainers.image.revision=$GIT_COMMIT
ARG GIT_REPO=unspecified
LABEL org.opencontainers.image.source=$GIT_REPO
ARG DOCKER_TAG=unspecified
LABEL org.opencontainers.image.version=$DOCKER_TAG
