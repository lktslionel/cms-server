#!/bin/bash

set -e

source etc/docker/x/extras/addons.sh



Step "Assemble"

docker build --force-rm \
    --build-arg PROJECT_NAME="${X_PROJECT_NAME}"\
    -f "${X_PROJECT_DIR}/etc/docker/Dockerfile" .

Done