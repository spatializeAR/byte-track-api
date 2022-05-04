#!/bin/bash -xe

build_macos() {
  OUTDIR=build/Release

  # Build macOS Arm64
  cmake -S . -B build -G Xcode -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake -DPLATFORM=MAC_ARM64
  cmake --build build --config Release
  mv $OUTDIR/libbytetrack.dylib $OUTDIR/libbytetrack-arm64.dylib
  # Build macOS x86_64
  cmake -S . -B build -G Xcode -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake -DPLATFORM=MAC
  cmake --build build --config Release
  mv $OUTDIR/libbytetrack.dylib $OUTDIR/libbytetrack-x86_64.dylib
  # Combine them into a fat library
  lipo -create -output $OUTDIR/libbytetrack.dylib $OUTDIR/libbytetrack-arm64.dylib $OUTDIR/libbytetrack-x86_64.dylib
}

build_ios() {
  cmake -S . -B build -G Xcode -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake -DPLATFORM=OS64COMBINED -DENABLE_BITCODE=1
  cmake --build build --config Release
}

build_android() {
  NDK=$ANDROID_HOME/ndk-bundle/

  cmake -S . -B build
  cmake \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_SYSTEM_VERSION=30 \
    -DCMAKE_ANDROID_ARCH_ABI=arm64-v8a \
    -DCMAKE_ANDROID_NDK=$NDK \
    -DCMAKE_ANDROID_STL_TYPE=c++_static \
    --build build
}

case "$1" in
  "--macos")
    build_macos
  ;;

  "--ios")
    build_ios
  ;;

  "--android")
    build_android
  ;;

  "--all")
    build_macos
    build_ios
    build_android
  ;;

  *)
    echo 'usage: ./build.sh [--macos|--ios|--android|--all]'
    exit 1
  ;;
esac
