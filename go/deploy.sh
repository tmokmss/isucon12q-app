#!/bin/bash -x
set -ex

echo "start deploy ${USER}"
BINARY='isuports'
SERVICE='isuports.service'

GOOS=linux go build -o $BINARY
for server in isu11 isu31 isu21; do
    ssh -t $server "sudo systemctl stop ${SERVICE}"
    scp ./$BINARY $server:/home/isucon/webapp/go/
    ssh -t $server "sudo systemctl start ${SERVICE}"
done

echo "finish deploy ${USER}"
