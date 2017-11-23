#!/bin/bash 

NAME=$(ls Build/macos | cut -d "." -f 1)
BIN="./Build/macos/${NAME}.app/Contents/MacOS/${NAME}"
LOG_FILE="Run.log"

${BIN} -logFile ${LOG_FILE}
cat ${LOG_FILE} | grep OUTPUT
rm ${LOG_FILE}

