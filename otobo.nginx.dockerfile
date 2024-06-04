# This is the build file for the OTOBO nginx Docker image.

# See bin/docker/build_docker_images.sh for how to create local builds.
# See also https://doc.otobo.io/manual/installation/10.0/en/content/installation-docker.html

# Use the latest nginx.
# This image is based on Debian 10 (Buster). The User is root.
FROM nginx:mainline

# install some required and optional Debian packages 
# hadolint ignore=DL3008
RUN apt-get update\
 && apt-get -y --no-install-recommends install\
 "less"\
 "nano"\
 "screen"\
 "tree"\
 "vim"\
 "certbot"\
 "python3-certbot-nginx"\
 && rm -rf /var/lib/apt/lists/*

# No need to run on the low ports 80 and 443,
# even though this would be possible as the master process runs as root.
EXPOSE 8080/tcp
EXPOSE 8443/tcp

# We want an UTF-8 console
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# This setting works in the devel environment.
# In the general case OTOBO_NGINX_WEB_HOST can be set when starting the container:
#   docker run -e OTOBO_NGINX_WEB_HOST=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+') -p 443:443 otobo_nginx
# Attention: specify OTOBO_WEB_PORT to 5000 in .env when
# starting HTTP with 'docker-compose -f docker-compose.yml up'
ENV OTOBO_NGINX_WEB_HOST          172.17.0.1
ENV OTOBO_NGINX_WEB_PORT          5000

# Not that these file need to be copied into a container.
# Alternatively /etc/ssl can be exported as a volume to the host.
ENV OTOBO_NGINX_SSL_CERTIFICATE      /etc/nginx/ssl/otobo_nginx-selfsigned.crt
ENV OTOBO_NGINX_SSL_CERTIFICATE_KEY  /etc/nginx/ssl/otobo_nginx-selfsigned.key

WORKDIR /etc/nginx

# move the old config out of the way
RUN mv conf.d/default.conf conf.d/default.conf.hidden

# new nginx config, will be modified by /docker-entrypoint.d/20-envsubst-on-templates.sh
# See 'Using environment variables in nginx configuration' in https://hub.docker.com/_/nginx .
# Actually there are two config templates in the directory 'templates'. One for plain Nginx and one for Nginx with
# Kerberos support. The not needed template is moved out of the way.
COPY templates/ templates
RUN mv templates/otobo_nginx-kerberos.conf.template templates/otobo_nginx-kerberos.conf.template.hidden
COPY snippets/  snippets

# Add some additional meta info to the image.
# This done at the end of the Dockerfile as changed labels and changed args invalidate the layer cache.
# The labels are compliant with https://github.com/opencontainers/image-spec/blob/master/annotations.md .
# For the standard build args passed by hub.docker.com see https://docs.docker.com/docker-hub/builds/advanced/.
LABEL maintainer='Team OTOBO <dev@otobo.io>'
LABEL org.opencontainers.image.authors='Team OTOBO <dev@otobo.io>'
LABEL org.opencontainers.image.description='OTOBO is the new open source ticket system with strong functionality AND a great look'
LABEL org.opencontainers.image.documentation='https://otobo.io'
LABEL org.opencontainers.image.licenses='GNU General Public License v3.0 or later'
LABEL org.opencontainers.image.title='OTOBO nginx'
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
