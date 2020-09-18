# This is the build file for the OTOBO Elasticsearch docker image.
# See also README_DOCKER.md.

# Use 7.8.0, because latest flag is not available
# This image is based on CentOS 7. The User is root.
FROM docker.elastic.co/elasticsearch/elasticsearch:7.8.0

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

LABEL maintainer="Team OTOBO <dev@otobo.org>"

# We want an UTF-8 console
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
