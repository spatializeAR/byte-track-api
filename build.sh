#!/bin/bash -xe

build_macos() {
  cmake -S . -B build -G Xcode -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake -DPLATFORM=MAC_ARM64
  cmake --build build --config Release
}

build_ios() {
  cmake -S . -B build
  echo 'todo'
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
    echo 'ios'
  ;;

  "--android")
    build_android
  ;;

  "--all")
    build_macos
  ;;

  "--run")
    echo 'run'
  ;;

  *)
    echo 'usage: ./build.sh [--macos|--ios|--android|--all|--run]'
    exit 1
  ;;
esac
