FROM node:11

RUN npm update -y -g npm
RUN apt-get update
RUN apt-get install -y vim avahi-daemon libavahi-compat-libdnssd-dev

VOLUME [ "/myapp" ]
