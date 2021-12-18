# Based on examples from the official AWS Thinkbox Deadline documentation
FROM junofx/polaris

COPY src/thinkbox/DeadlineClient.run /tmp/thinkboxsetup/

RUN /tmp/thinkboxsetup/DeadlineClient.run \
        --mode unattended \
        --unattendedmodeui minimal \
        --connectiontype Remote \
        --licenseserver @lic-thinkbox \
        --noguimode true \
        --restartstalled true \
    && cp -Rv /opt/Thinkbox/Deadline10/*.desktop /usr/share/applications/ \
    && rm -rfv /tmp/*

COPY src/polaris/deadline.ini /var/lib/Thinkbox/Deadline10/deadline.ini
