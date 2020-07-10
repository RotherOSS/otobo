# This is the build file for the OTOBO Elasticsearch docker image.
# See also README_DOCKER.md.

# Use 7.8.0, cause latest flag is not availible
FROM docker.elastic.co/elasticsearch/elasticsearch:7.8.0

# Install important plugins
RUN bin/elasticsearch-plugin install --batch ingest-attachment
RUN bin/elasticsearch-plugin install --batch analysis-icu
