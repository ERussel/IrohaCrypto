#!/bin/bash

LIBSODIUM_PATH="libsodium"
LIBSODIUM_BUILD="dist-build/ios.sh"
LIBSODIUM_IOS="libsodium-ios"

[ -d $LIBSODIUM_PATH ] && rm -rf $LIBSODIUM_PATH

git clone https://github.com/jedisct1/libsodium.git
(cd "$LIBSODIUM_PATH";
git checkout 675149b9b8b66ff44152553fb3ebf9858128363d;
autoreconf --install;
./"$LIBSODIUM_BUILD")

[ -d $LIBSODIUM_IOS ] && rm -rf $LIBSODIUM_IOS

mv "$LIBSODIUM_PATH/$LIBSODIUM_IOS" "$LIBSODIUM_IOS"

[ -d $LIBSODIUM_PATH ] && rm -rf $LIBSODIUM_PATH