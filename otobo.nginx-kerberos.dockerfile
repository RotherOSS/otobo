# This is the build file for the OTOBO nginx Docker image including Kerberos Single Sign On tools.

# See bin/docker/build_docker_images.sh for how to create local builds.
# See also https://doc.otobo.org/manual/installation/10.1/en/content/installation-docker.html

# I have found no better way than to first compile NGINX in a BUILDER container and then copy the
# finished ngx_http_auth_spnego_module.so into the NGINX container.
# If anyone knows a nicer way, please share.

# builder used to create a dynamic spnego auth module
# https://gist.github.com/hermanbanken/96f0ff298c162a522ddbba44cad31081

FROM nginx:mainline AS builder

ENV SPNEGO_AUTH_COMMIT_ID=v1.1.1
ENV SPNEGO_AUTH_COMMIT_ID_FILE=1.1.1

RUN apt-get update\
 && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install\
        gcc \
        libc-dev \
        make \
        libpcre3-dev \
        zlib1g-dev \
        libkrb5-dev \
        wget

RUN set -x && \
    cd /usr/src \
    NGINX_VERSION="$( nginx -v 2>&1 | awk -F/ '{print $2}' )" && \
    NGINX_CONFIG="$( nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p' )" && \
    wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
    wget https://github.com/stnoonan/spnego-http-auth-nginx-module/archive/${SPNEGO_AUTH_COMMIT_ID}.tar.gz -O spnego-http-auth.tar.gz

RUN cd /usr/src && \
    NGINX_CONFIG="$( nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p' )" && \
    tar -xzC /usr/src -f nginx.tar.gz && \
    tar -xzvf spnego-http-auth.tar.gz && \
    SPNEGO_AUTH_DIR="$( pwd )/spnego-http-auth-nginx-module-${SPNEGO_AUTH_COMMIT_ID_FILE}" && \
    cd "/usr/src/nginx-${NGINX_VERSION}" && \
    ./configure --with-compat "${NGINX_CONFIG}" --add-dynamic-module="${SPNEGO_AUTH_DIR}" && \
    make modules && \
    cp objs/ngx_*_module.so /usr/lib/nginx/modules/



# Use the latest nginx.
# This image is based on Debian 10 (Buster). The User is root.
FROM nginx:mainline AS otobo-nginx-kerberos-webproxy

# Copy the nginx module ngx_http_auth_spnego_module.so to the official nginx container
COPY --from=builder /usr/lib/nginx/modules/ngx_http_auth_spnego_module.so /usr/lib/nginx/modules

# install some required and optional Debian packages
# hadolint ignore=DL3008
RUN apt-get update\
 && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install\
 "less"\
 "nano"\
 "screen"\
 "tree"\
 "vim"\
 "krb5-user"\
 "libpam-krb5"\
 "libpam-ccreds"\
 "krb5-multidev"\
 "libkrb5-dev"\
 "certbot"\
 "python3-certbot-nginx"\
 && rm -rf /var/lib/apt/lists/*

# No need to run on the low ports 80 and 443,
# even though this would be possible as the master process runs as root.
EXPOSE 8080/tcp
EXPOSE 8443/tcp

# We want an UTF-8 console
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# This setting works in the devel environment.
# In the general case OTOBO_NGINX_WEB_HOST can be set when starting the container:
#   docker run -e OTOBO_NGINX_WEB_HOST=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+') -p 443:443 otobo_nginx
# Attention: specify OTOBO_WEB_PORT to 5000 in .env when
# starting HTTP with 'docker-compose -f docker-compose.yml up'
ENV OTOBO_NGINX_WEB_HOST=172.17.0.1
ENV OTOBO_NGINX_WEB_PORT=5000
ENV OTOBO_WEB_HTTPS_PORT=443

# Not that these file need to be copied into a container.
# Alternatively /etc/ssl can be exported as a volume to the host.
ENV OTOBO_NGINX_SSL_CERTIFICATE=/etc/nginx/ssl/otobo_nginx-selfsigned.crt
ENV OTOBO_NGINX_SSL_CERTIFICATE_KEY=/etc/nginx/ssl/otobo_nginx-selfsigned.key

WORKDIR /etc/nginx

# move the old config out of the way
RUN mv conf.d/default.conf conf.d/default.conf.hidden

# The new nginx config, will be modified by /docker-entrypoint.d/20-envsubst-on-templates.sh.
# See 'Using environment variables in nginx configuration' in https://hub.docker.com/_/nginx .
# Actually there are two config templates in the directory 'templates'. One for plain Nginx and one for Nginx with
# Kerberos support. The not needed template is moved out of the way.
COPY templates/ templates
RUN mv templates/otobo_nginx.conf.template templates/otobo_nginx.conf.template.hidden
COPY snippets/  snippets

# When Kerberos is active we also generate /etc/krb5.conf from the template in templates/kerberos
COPY kerberos/templates/ kerberos/templates
COPY docker-entrypoint.d/21-envsubst-on-krb5-conf.sh /docker-entrypoint.d/

# Copy text to line 4 - load Kerberos module in nginx.conf
RUN sed '4 i\load_module modules/ngx_http_auth_spnego_module.so;' -i /etc/nginx/nginx.conf

# Add some additional meta info to the image.
# This done at the end of the Dockerfile as changed labels and changed args invalidate the layer cache.
# The labels are compliant with https://github.com/opencontainers/image-spec/blob/master/annotations.md .
# For the standard build args passed by hub.docker.com see https://docs.docker.com/docker-hub/builds/advanced/.
LABEL maintainer='Team OTOBO <dev@otobo.org>'
LABEL org.opencontainers.image.authors='Team OTOBO <dev@otobo.org>'
LABEL org.opencontainers.image.description='OTOBO is the new open source ticket system with strong functionality AND a great look'
LABEL org.opencontainers.image.documentation='https://otobo.org'
LABEL org.opencontainers.image.licenses='GNU General Public License v3.0 or later'
LABEL org.opencontainers.image.title='OTOBO nginx Kerberos SSO'
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
