FROM prasad7676/base-ubuntu:latest

LABEL maintainer="IntHunter(Prasad Patel)"

ENV PLEX_DOWNLOAD="https://downloads.plex.tv/plex-media-server/1.14.1.5488-cc260c476/plexmediaserver_1.14.1.5488-cc260c476_amd64.deb" 

RUN apt-get update && \
	apt-get -y install udev avahi-daemon dbus curl && \
	## DOwnload And Install Plex ###
	curl -o /tmp/plexmediaserver.deb -L \
	"${PLEX_DOWNLOAD}" && \
	dpkg -i /tmp/plexmediaserver.deb && \
	## Remove any Download From Temp Folder ##
	apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/* \
	## Create Some Directory For Plex Media ##
	mkdir /Movies /Music /Photos

COPY root/ /
EXPOSE 32400/tcp 3005/tcp 8324/tcp 32469/tcp 1900/udp 32410/udp 32412/udp 32413/udp 32414/udp
VOLUME /root
