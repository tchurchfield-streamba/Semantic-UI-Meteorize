FROM node:7.2
# https://superuser.com/a/1784565
# https://unix.stackexchange.com/a/755022
RUN echo "deb [trusted=yes]  http://archive.debian.org/debian/ jessie main" > /etc/apt/sources.list
RUN echo "deb-src [trusted=yes] http://archive.debian.org/debian/ jessie main" >> /etc/apt/sources.list
RUN echo "deb [trusted=yes] http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list
RUN echo "deb-src [trusted=yes] http://archive.debian.org/debian/ jessie main" >> /etc/apt/sources.list

RUN apt-get -y update && apt-get -y upgrade && rm -rf /var/cache/apt/*
RUN npm install -g gulp@3.8.11
USER node
RUN curl https://install.meteor.com/ | sh
RUN echo "PATH=/home/node/.meteor:$PATH" >> ~/.bashrc
WORKDIR /app
