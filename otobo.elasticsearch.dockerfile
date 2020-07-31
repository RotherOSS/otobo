# This is the build file for the OTOBO Elasticsearch docker image.
# See also README_DOCKER.md.

# Use 7.8.0, because latest flag is not available
# This image is based on CentOS 7. The User is root.
FROM docker.elastic.co/elasticsearch/elasticsearch:7.8.0

# take arguments that were passed via --build-arg
ARG GIT_COMMIT=unspecified
ARG GIT_BRANCH=unspecified

# install system tools
RUN packages=$( echo \
        "less" \
        "nano" \
        "tree" \
        "vim" \
    ) \
    && yum install -y $packages

# Install important plugins
RUN bin/elasticsearch-plugin install --batch ingest-attachment
RUN bin/elasticsearch-plugin install --batch analysis-icu

# We want an UTF-8 console
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Add some additional meta info to the image.
# This done near the end as changes labels invalidate the layer cache.
LABEL maintainer="Team OTOBO <dev@otobo.org>"
LABEL git_commit=$GIT_COMMIT
LABEL git_branch=$GIT_BRANCH
