#!/bin/bash

set -ex
if [ "$(uname)" != "Darwin" ]; then
    echo "Only MacOS is supported"
    exit 1
fi

ED25519_PATH="iroha-ed25519"
CMAKE_PATH="ios-cmake"
LIB_PATH="lib"
UNIVERSAL_PATH="IrohaCryptoImp"


command -v xcodebuild > /dev/null 2>&1 || { echo >&2 "xcodebuild is required but it's not installed.  Aborting.";
    exit 1; }

CORES=$(getconf _NPROCESSORS_ONLN)
if [ "$CORES" -gt 1 ]; then
    CORES=$((CORES - 1))
fi

[ -d $ED25519_PATH ] && rm -rf $ED25519_PATH
[ -d $CMAKE_PATH ] && rm -rf $CMAKE_PATH

# ios toolchain file for cmake
git clone https://github.com/leetal/ios-cmake
(cd "./$CMAKE_PATH";
git checkout 096778e59743648b37b871edb6c4e57facf5866e)

git clone https://github.com/hyperledger/iroha-ed25519.git
(cd "./$ED25519_PATH";
git checkout tags/1.3.1)

[ -d $LIB_PATH ] && rm -rf $LIB_PATH
mkdir $LIB_PATH

PLATFORMS=( "SIMULATOR" "SIMULATOR64" "OS" )
BUILDS=()

for PLATFORM in ${PLATFORMS[*]}; do
	PLATFORM_PATH="$LIB_PATH/$PLATFORM"
	BUILDS+=("$PLATFORM_PATH/lib/libed25519.a")
	IOS_TOOLCHAIN_ARGS=( -DCMAKE_TOOLCHAIN_FILE="$PWD"/ios-cmake/ios.toolchain.cmake -DIOS_PLATFORM=${PLATFORM} )
	INSTALL_ARGS=( -DCMAKE_INSTALL_PREFIX=$PLATFORM_PATH )

	[ -d $PLATFORM_PATH ] && rm -rf $PLATFORM_PATH
	[ -d "$ED25519_PATH/build" ] && rm -rf "$ED25519_PATH/build"

	cmake -DCMAKE_BUILD_TYPE="Release" "${IOS_TOOLCHAIN_ARGS[@]}" "${INSTALL_ARGS[@]}" -DTESTING=OFF -DBUILD=STATIC -H./iroha-ed25519 -B./iroha-ed25519/build
	VERBOSE=1 cmake --build ./iroha-ed25519/build --target install -- -j"$CORES"
done

[ -d $UNIVERSAL_PATH ] && rm -rf $UNIVERSAL_PATH
mkdir $UNIVERSAL_PATH

lipo -create ${BUILDS[@]} -output "$UNIVERSAL_PATH/libed25519.a"
cp -R "$LIB_PATH/${PLATFORMS[0]}/include/ed25519/ed25519" "$UNIVERSAL_PATH/include"

[ -d $ED25519_PATH ] && rm -rf $ED25519_PATH
[ -d $CMAKE_PATH ] && rm -rf $CMAKE_PATH
[ -d $LIB_PATH ] && rm -rf $LIB_PATH