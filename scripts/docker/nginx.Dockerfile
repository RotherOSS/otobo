# This is the build file for the OTOBO nginx docker image.
# See also README_DOCKER.md.

# use the latest nginx
FROM nginx:mainline

# mostly for documentation
EXPOSE 80/tcp
EXPOSE 443/tcp

# This setting works in the devel environment.
# In the general case DOCKER_HOST can be set when starting the container:
#   docker run -e DOCKER_HOST=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+') -p 80:80 otobo_nginx
ENV DOCKER_HOST          172.17.0.1

# Not that these file need to be copied into a container.
# Alternatively /etc/ssl can be exported as a volume to the host.
ENV SSL_CERTIFICATE      /etc/nginx/ssl/otobo_nginx-selfsigned.crt
ENV SSL_CERTIFICATE_KEY  /etc/nginx/ssl/otobo_nginx-selfsigned.key

WORKDIR /etc/nginx

# move the old config out of the way
RUN mv conf.d/default.conf conf.d/default.conf.hidden

# new nginx config, will be modified by /docker-entrypoint.d/20-envsubst-on-templates.sh
# See 'Using environment variables in nginx configuration' in https://hub.docker.com/_/nginx
COPY scripts/nginx/templates/ templates
COPY scripts/nginx/snippets/  snippets
