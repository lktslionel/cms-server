#!/bin/bash

set -e

source $X_XTRS_DIR/addons.sh

Step "Run"

Log "Available env vars:"

Task "Checking required env vars "
#: "${CMSSRV_XYZ_PARAM:?<Error Msg>}"
#: "${CMSSRV_XYZ_PARAM:?<Error Msg>}"
#: "${CMSSRV_XYZ_PARAM:?<Error Msg>}"


Task "Initializing App"
Check $?
Done

Task "Checking config"
Check $?
Done

Task "Starting App"
cd $X_APP_DIR
Check $?

Done




