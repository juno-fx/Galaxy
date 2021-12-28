echo "Setting repository..."

/tmp/thinkboxsetup/DeadlineRepository.run \
    --mode unattended \
    --dbhost "$MONGO" \
    --debuglevel 0 \
    --setpermissions 7777 \
    --dbport "$MONGO_PORT" \
    --prefix /mnt/deadline \
    --installmongodb false \
    --prepackagedDB false

echo "Repository setup!"
echo "Installing client..."

/tmp/thinkboxsetup/DeadlineClient.run \
    --mode unattended \
    --unattendedmodeui minimal \
    --repositorydir /mnt/deadline \
    --prefix /opt/Thinkbox/Deadline \
    --noguimode true \
    --restartstalled false

echo "Client installed!"
echo "Running cleanup..."

rm -rfv /tmp/*

echo "Launching RCS"
/opt/Thinkbox/Deadline/bin/deadlinercs
