# This is the build file for the OTOBO web docker image.
# The services OTOBO web and OTOBO daemon use the same image.
# There is also an extra build target otobo-web-kerberos that add support for Kerberos.

# See also bin/docker/build_docker_images.sh
# See also https://docs.docker.com/docker-hub/builds/advanced/
# See also https://doc.otobo.org/manual/installation/10.1/en/content/installation-docker.html

# This file should never be actually used as build/hooks should mandate that the otobo.web.dockerfile
# is used. But there is a suspicion that hub.docker.com checkes whether the file exists

FROM perl:5.38
