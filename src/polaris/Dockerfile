# Bring in cached installers
FROM localhost:5000/installers as installers

# Basic workstation with deadline integration
FROM junofx/polaris

COPY --from=installers /thinkbox/DeadlineClient.run /tmp/thinkboxsetup/

RUN apt update && apt install  -y \
      libxcb-xinput0 \
    && /tmp/thinkboxsetup/DeadlineClient.run \
        --mode unattended \
        --unattendedmodeui minimal \
        --connectiontype Remote \
        --licenseserver @lic-thinkbox \
        --noguimode true \
        --restartstalled true \
    && cp -Rv /opt/Thinkbox/Deadline10/*.desktop /usr/share/applications/ \
    && rm -rfv /tmp/*

COPY polaris/*.desktop /usr/share/applications/
COPY thinkbox/config/client.ini /var/lib/Thinkbox/Deadline10/deadline.ini
