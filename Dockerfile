FROM debian:jessie
MAINTAINER Jean-Avit Promis "docker@katagena.com"

##wget to DL
##jdk for eclipse
##php5 php5-cli for php dev
##git svn for team
##libcanberra-gtk3-module for graph
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq install wget openjdk-7-jdk php5 php5-cli git subversion libcanberra-gtk3-module && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget http://mirror.ibcp.fr/pub/eclipse//technology/epp/downloads/release/mars/1/eclipse-php-mars-1-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz -q && \
    tar -xf /tmp/eclipse.tar.gz -C /opt && \
    rm /tmp/eclipse.tar.gz

COPY install.sh /install.sh
RUN chmod +x /install.sh

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/developer

COPY home/.wakatime.cfg /home/developer/.wakatime.cfg
COPY configuration/ /opt/eclipse/configuration/
COPY metadata/ /home/developer/metadata/

RUN chown developer: /install.sh
RUN chown -R developer: /home/developer/.wakatime.cfg
RUN chown -R developer: /opt/eclipse/
RUN chown -R developer: /home/developer/metadata/

USER developer
ENV HOME /home/developer

CMD /install.sh
