#!/bin/bash

set -ex
if [ "$(uname)" != "Darwin" ]; then
    echo "Only MacOS is supported"
    exit 1
fi

GIT_PATH="secp256k1"
AUTOTOOLS_PATH="ios-autotools"
LIB_DIR="ECC256k1"
LIB_NAME="ECC256k1.framework"


command -v xcodebuild > /dev/null 2>&1 || { echo >&2 "xcodebuild is required but it's not installed.  Aborting.";
    exit 1; }

CORES=$(getconf _NPROCESSORS_ONLN)
if [ "$CORES" -gt 1 ]; then
    CORES=$((CORES - 1))
fi

[ -d $GIT_PATH ] && rm -rf $GIT_PATH
[ -d $AUTOTOOLS_PATH ] && rm -rf $AUTOTOOLS_PATH

# ios toolchain file for autotools
git clone https://github.com/bbqsrc/ios-autotools.git
(cd "./$AUTOTOOLS_PATH";
git checkout 13a96f6e84101ed1e07f74919cda5b2079e68442)

git clone https://github.com/bitcoin-core/secp256k1.git
(cd "./$GIT_PATH";
git checkout 96d8ccbd16090551aa003bfa4acd108b0496cb89)

[ -d $LIB_DIR ] && rm -rf $LIB_DIR
mkdir $LIB_DIR

(cd $GIT_PATH; ./autogen.sh; PREFIX=$(realpath "../$LIB_DIR") SDKTARGET="9.0" ../$AUTOTOOLS_PATH/autoframework $LIB_DIR libsecp256k1.a)

[ -d $LIB_NAME ] && rm -rf $LIB_NAME
mv "$LIB_DIR/Frameworks/$LIB_NAME" "$LIB_NAME"

[ -d $LIB_DIR ] && rm -rf $LIB_DIR
[ -d $GIT_PATH ] && rm -rf $GIT_PATH
[ -d $AUTOTOOLS_PATH ] && rm -rf $AUTOTOOLS_PATH