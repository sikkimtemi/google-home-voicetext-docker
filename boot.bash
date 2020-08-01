#/bin/bash

service dbus start
avahi-daemon --daemonize --no-drop-root
sleep 1
node file-server.js &
node firestore.js &
node api-server.js
