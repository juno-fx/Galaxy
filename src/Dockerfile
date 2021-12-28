# Bring in cached installers
FROM localhost:5000/installers as installers

# Based on examples from the official AWS Thinkbox Deadline documentation
FROM ubuntu:20.04 as server

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


COPY --from=installers /thinkbox/DeadlineRepository.run /tmp/thinkboxsetup/
COPY --from=installers /thinkbox/DeadlineClient.run /tmp/thinkboxsetup/
COPY thinkbox/launch.sh /opt/juno/
COPY thinkbox/config/server.ini /var/lib/Thinkbox/Deadline10/deadline.ini

RUN chmod +x /opt/juno/launch.sh

WORKDIR /opt/Thinkbox/Deadline/bin/

CMD /opt/juno/launch.sh

# using cached server image
FROM server as client

RUN /tmp/thinkboxsetup/DeadlineClient.run \
        --mode unattended \
        --unattendedmodeui minimal \
        --repositorydir /mnt/deadline \
        --prefix /opt/Thinkbox/Deadline \
        --noguimode true \
        --restartstalled true \
    && rm -rfv /tmp/*

COPY thinkbox/config/worker.ini /var/lib/Thinkbox/Deadline10/deadline.ini

CMD /opt/Thinkbox/Deadline/bin/deadlinelauncher

# Basic workstation with deadline integration
FROM junofx/polaris as workstation

COPY --from=client /opt/Thinkbox /opt/Thinkbox

RUN apt update && apt install  -y \
      libxcb-xinput0 \
    && cp -Rv /opt/Thinkbox/Deadline/*.desktop /usr/share/applications/ \
    && echo >> /usr/share/applications/deadlinemonitor10.desktop \
    && echo "Categories=Polaris" >> /usr/share/applications/deadlinemonitor10.desktop \
    && rm -rfv /tmp/* \
    && mkdir -p /var/log/Thinkbox/Deadline10

COPY polaris/Nuke.desktop /usr/share/applications/
COPY thinkbox/config/client.ini /var/lib/Thinkbox/Deadline10/deadline.ini
