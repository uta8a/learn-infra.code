#!/bin/sh
set -ue
apt update
apt install -y netcat
timeout 30 sh -c "until nc -vz localhost 3306; do echo 'sleep' && sleep 1; done" && mysql -h localhost -u root -pMariaPass < "/init.sql"
