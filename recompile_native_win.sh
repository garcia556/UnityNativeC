#!/bin/bash 

DIR="./UnitySrc/Assets/NaPl/Plugins"
CC="x86_64-w64-mingw32-gcc"

SRC="${DIR}/NaPlContent.c"
OUTPUT="${DIR}/NaPlContent.dll"

CFLAGS_ARCH=""
CFLAGS_LIB="-shared"
CFLAGS="${CFLAGS_ARCH} ${CFLAGS_LIB}"

cmd="${CC} ${CFLAGS} -o ${OUTPUT} ${SRC}"
echo ${cmd}
${cmd}

