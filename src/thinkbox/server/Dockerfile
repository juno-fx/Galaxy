# Based on examples from the official AWS Thinkbox Deadline documentation
FROM ubuntu:20.04

ARG VERSION

RUN apt-get update \
    && apt-get install apt-utils -y \
    && apt-get -y upgrade \
    && apt-get install -y \
      dirmngr \
      gnupg \
      apt-transport-https \
      ca-certificates \
      software-properties-common \
      bzip2 \
    && apt-key adv \
      --keyserver hkp://keyserver.ubuntu.com:80 \
      --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && apt-add-repository 'deb https://download.mono-project.com/repo/ubuntu stable-focal main' \
    && apt update -y \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
      mono-complete \
    && mkdir -p /tmp/thinkboxsetup/


COPY src/thinkbox/DeadlineRepository.run /tmp/thinkboxsetup/
COPY src/thinkbox/DeadlineClient.run /tmp/thinkboxsetup/
COPY src/thinkbox/server/launch.sh /opt/juno/
COPY src/thinkbox/server/deadline.ini /var/lib/Thinkbox/Deadline10/deadline.ini

RUN chmod +x /opt/juno/launch.sh

WORKDIR /opt/Thinkbox/Deadline/bin/

CMD /opt/juno/launch.sh
