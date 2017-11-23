#!/bin/bash 

TARGET=$1
OUTPUT=$2

if [ "${TARGET}" == "" ]; then
	echo "Target not set"
	exit 1
fi

if [ "${OUTPUT}" == "" ]; then
	echo "Output not set"
	exit 2
fi

BIN="/Applications/Unity/Unity.app/Contents/MacOS/Unity"
PROJECT_PATH="$(pwd)/UnitySrc"
LOG_FILE="$(pwd)/Build.log"
BUILD_METHOD="BuildManager.Run"

error_code=0

echo "Building project for ${TARGET} saving result to \"${OUTPUT}\" ..."
${BIN}									\
	-batchmode							\
	-nographics							\
	-silent-crashes						\
	-logFile "${LOG_FILE}"				\
	-projectPath "${PROJECT_PATH}"		\
	-buildTarget ${TARGET}				\
	-output "${OUTPUT}"					\
	-executeMethod "${BUILD_METHOD}"	\
	-quit

if [ $? == 0 ]; then
	echo "Project build completed successfully"
else
	echo "Build failed with code $?"
	error_code=1
fi

echo "Build logs:"
cat ${LOG_FILE}
rm ${LOG_FILE}

echo "Finishing with code ${error_code}"
exit ${error_code}

