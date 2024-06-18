#!/bin/sh
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
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

# /docker-entrypoint.d/21-envsubst-on-krb5_conf.sh - replace environment variables in /etc/krb5.conf

# This script works just like /docker-entrypoint.d/20-envsubst-on-templates.sh in the Nginx base Docker image.
# A template file for /etc/krb5.conf is set up in /etc/nginx/templates/kerberos/krb5.conf.template.
# The command envsubst replaces environment variables in the template and writes the output to /etc/krb6.conf.
supported_envs='${OTOBO_NGINX_KERBEROS_REALM} ${OTOBO_NGINX_KERBEROS_KDC} ${OTOBO_NGINX_KERBEROS_ADMIN_SERVER} ${OTOBO_NGINX_KERBEROS_DEFAULT_DOMAIN}'
template_dir="${NGINX_ENVSUBST_TEMPLATE_DIR:-/etc/nginx/config/template-custom}"

envsubst "$supported_envs" < "$template_dir/../../kerberos/templates/krb5.conf.template" > /etc/krb5.conf
