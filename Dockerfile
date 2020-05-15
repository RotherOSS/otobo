# This is the build file for the OTOBO docker image.

# See: https://perlmaven.com/getting-started-with-perl-on-docker

# Here are some commands for Docker newbys:
# show version:      sudo docker version
# build an image:    sudo docker build -t otobodocker .
# run the new image: sudo docker run otobodocker .


# use the latest Perl on Debian 10 (buster). As of 2020-05-15.
# cpanm is already installed
FROM perl:5.30.2-buster

# install some required Debian packages
RUN apt-get update
RUN apt-get -y install tree default-mysql-server default-mysql-client

# install OTOBO
RUN mkdir /opt/otobo
COPY . /opt/otobo

# continue working in /opt/otobo
WORKDIR /opt/otobo

# just to see that it worked
CMD pwd && tree /opt/otobo
