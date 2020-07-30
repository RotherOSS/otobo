# This is the build file for the OTOBO Elasticsearch docker image.
# See also README_DOCKER.md.

# Use 7.8.0, because latest flag is not available
FROM docker.elastic.co/elasticsearch/elasticsearch:7.8.0

# take arguments that were passed via --build-arg
ARG GIT_COMMIT=unspecified
ARG GIT_BRANCH=unspecified

# add some additional meta info to the image
LABEL maintainer="Bernhard Schmalhofer <Bernhard.Schmalhofer@gmx.de>"
LABEL git_commit=$GIT_COMMIT
LABEL git_branch=$GIT_BRANCH

# Install important plugins
RUN bin/elasticsearch-plugin install --batch ingest-attachment
RUN bin/elasticsearch-plugin install --batch analysis-icu

# We want an UTF-8 console
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
