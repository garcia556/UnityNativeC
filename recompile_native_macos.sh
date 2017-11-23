#!/bin/bash 

DIR="./UnitySrc/Assets/NaPl/Plugins"
CC="cc"

SRC="${DIR}/NaPlContent.c"
OUTPUT="${DIR}/NaPlContent.bundle/Contents/MacOS/NaPlContent"

CFLAGS_ARCH="-arch i386 -arch x86_64"
CFLAGS_LIB="-shared -undefined dynamic_lookup"
CFLAGS="${CFLAGS_ARCH} ${CFLAGS_LIB}"

cmd="${CC} ${CFLAGS} -o ${OUTPUT} ${SRC}"
echo ${cmd}
${cmd}

