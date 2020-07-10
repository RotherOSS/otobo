# This is the build file for the OTOBO Elasticsearch docker image.
# See also README_DOCKER.md.

# Use 7.8.0, cause latest flag is not availible
FROM docker.elastic.co/elasticsearch/elasticsearch:7.8.0

# Install important plugins
RUN bin/elasticsearch-plugin install --batch ingest-attachment
RUN bin/elasticsearch-plugin install --batch analysis-icu

# remove x-pack because of license problems spamming log file with massive amounts of errors
# TODO: Needed?
RUN bin/elasticsearch-plugin remove x-pack --purge \
    &&  sed -i 's/^xpack/#xpack/' config/elasticsearch.yml
