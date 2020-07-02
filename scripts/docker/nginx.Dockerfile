# This is the build file for the OTOBO nginx docker image.
# See also README_DOCKER.md.

# use the latest nginx
FROM nginx:mainline

# let nginx handle the static content
# The static files must be readable by the user nginx.
COPY --chown=nginx:nginx var/httpd/htdocs /usr/share/nginx/html/otobo-web

# move the old config out of the way
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.hidden

# new nginx config, will be modified by /docker-entrypoint.d/20-envsubst-on-templates.sh
COPY scripts/nginx/otobo_nginx.conf /etc/nginx/conf.d/otobo_nginx.conf
