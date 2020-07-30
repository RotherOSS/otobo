# This is the build file for the OTOBO Elasticsearch docker image.
# See also README_DOCKER.md.

# Use 7.8.0, because latest flag is not available
FROM docker.elastic.co/elasticsearch/elasticsearch:7.8.0

LABEL maintainer="Bernhard Schmalhofer <Bernhard.Schmalhofer@gmx.de>"

# Install important plugins
RUN bin/elasticsearch-plugin install --batch ingest-attachment
RUN bin/elasticsearch-plugin install --batch analysis-icu

# We want an UTF-8 console
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
