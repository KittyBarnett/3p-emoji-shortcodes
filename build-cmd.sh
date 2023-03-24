#!/usr/bin/env bash

# turn on verbose debugging output for parabuild logs.
exec 4>&1; export BASH_XTRACEFD=4; set -x
# make errors fatal
set -e
# complain about unset env variables
set -u

# check autobuild is around or fail
if [ -z "$AUTOBUILD" ] ; then
    exit 1
fi

if [ "$OSTYPE" = "cygwin" ] ; then
    autobuild="$(cygpath -u $AUTOBUILD)"
else
    autobuild="$AUTOBUILD"
fi

STAGING_DIR="$(pwd)"
TOP_DIR="$(dirname "$0")"
SRC_DIR="${TOP_DIR}/emojibase"

python.exe "$TOP_DIR"/gen_emoji_characters.py "$SRC_DIR"/packages/data stage/xui

mkdir -p "$STAGING_DIR"/LICENSES
cp "$SRC_DIR"/LICENSE "$STAGING_DIR"/LICENSES/emojibase-license.txt

version="1.0.0"
build=${AUTOBUILD_BUILD_ID:=0}
echo "${version}.${build}" > "${STAGING_DIR}/VERSION.txt"
