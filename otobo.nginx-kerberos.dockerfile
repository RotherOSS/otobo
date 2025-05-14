# This Dockerfile is needed for the OTOBO nginx docker image with support for Kerberos.
#
# Actually, this file is not used for building the image. It is only a standin as
# Docker Hub checks the existence of the configured Dockerfile when it automatically
# builds images. For the actual build the hook in the script hooks/build is called.
# That script declares that the Dockerfile otobo.nginx-kerberos.dockerfile is to be used for building the image.
#
# There is an extra build target otobo-ngix-kerberos that add support for Kerberos. This
# complicated setup allows that a multiple images are build with a single Dockerfile. Thus
# it is guaranteed that the images do not diverge.

# See also bin/docker/build_docker_images.sh
# See also https://docs.docker.com/docker-hub/builds/advanced/
# See also https://doc.otobo.org/manual/installation/10.1/en/content/installation-docker.html

# just to have a valid Dockerfile
FROM scratch
