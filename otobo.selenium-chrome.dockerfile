# This is the build file for the OTOBO selenium-chrome Docker image.

# See bin/docker/build_docker_images.sh for how to build locally.
# See also https://doc.otobo.org/manual/installation/10.0/en/content/installation-docker.html

# note that selenium/standalone-chrome-debug:3.141.59-20210607 has changed behavior
FROM selenium/standalone-chrome-debug:3.141.59-20210422 AS otobo-selenium-chrome

# For the VNC-viewer, e.g. Remmina
EXPOSE 5900/tcp

# Make sure that /opt/otobo exists and is writable by $OTOBO_USER.
RUN sudo mkdir --parent /opt/otobo/scripts/test
RUN sudo chown -R seluser:seluser /opt/otobo

# Build context is scripts/test/sample
COPY --chown=seluser:seluser . /opt/otobo/scripts/test/sample

# Add some additional meta info to the image.
# This done at the end of the Dockerfile as changed labels and changed args invalidate the layer cache.
# The labels are compliant with https://github.com/opencontainers/image-spec/blob/master/annotations.md .
# For the standard build args passed by hub.docker.com see https://docs.docker.com/docker-hub/builds/advanced/.
LABEL maintainer='Team OTOBO <dev@otobo.org>'
LABEL org.opencontainers.image.authors='Team OTOBO <dev@otobo.org>'
LABEL org.opencontainers.image.description='OTOBO is the new open source ticket system with strong functionality AND a great look'
LABEL org.opencontainers.image.documentation='https://otobo.org'
LABEL org.opencontainers.image.licenses='GNU General Public License v3.0 or later'
LABEL org.opencontainers.image.title='OTOBO selenium-chrome'
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
