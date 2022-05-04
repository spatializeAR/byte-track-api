#!/bin/bash -xe

build_macos() {
  BUILDDIR=build.macos
  OUTDIR=$BUILDDIR/Release

  # Build macOS Arm64
  cmake -S . -B $BUILDDIR -G Xcode \
    -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake \
    -DPLATFORM=MAC_ARM64
  cmake --build $BUILDDIR --config Release
  mv $OUTDIR/libbytetrack.dylib $OUTDIR/libbytetrack-arm64.dylib

  # Build macOS x86_64
  cmake -S . -B $BUILDDIR -G Xcode \
    -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake \
    -DPLATFORM=MAC
  cmake --build $BUILDDIR --config Release
  mv $OUTDIR/libbytetrack.dylib $OUTDIR/libbytetrack-x86_64.dylib

  # Combine them into a fat library
  lipo -create -output $OUTDIR/libbytetrack.dylib \
    $OUTDIR/libbytetrack-arm64.dylib \
    $OUTDIR/libbytetrack-x86_64.dylib
}

build_ios() {
  BUILDDIR=build.ios

  cmake -S . -B $BUILDDIR -G Xcode \
    -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake \
    -DPLATFORM=OS64COMBINED \
    -DENABLE_BITCODE=1 \
    -DIS_STATIC_LIBRARY=1
  cmake --build $BUILDDIR --config Release
}

build_android() {
  
  NDK=$ANDROID_HOME/ndk-bundle/

  # Build Android arm64-v8a
  BUILDDIR=build.android.arm64-v8a
  cmake -S . -B $BUILDDIR \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_SYSTEM_VERSION=29 \
    -DCMAKE_ANDROID_ARCH_ABI=arm64-v8a \
    -DCMAKE_ANDROID_NDK=$NDK \
    -DCMAKE_ANDROID_STL_TYPE=c++_static
  cmake --build $BUILDDIR --config Release
  
  # Build Android armeabi-v7a
  BUILDDIR=build.android.armeabi-v7a
  cmake -S . -B $BUILDDIR \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_SYSTEM_VERSION=29 \
    -DCMAKE_ANDROID_ARCH_ABI=armeabi-v7a \
    -DCMAKE_ANDROID_NDK=$NDK \
    -DCMAKE_ANDROID_STL_TYPE=c++_static
  cmake --build $BUILDDIR --config Release
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
