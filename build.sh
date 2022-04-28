#!/bin/bash -xe

build_macos() {
  cmake -S . -B build
  cmake --build build
}

case "$1" in
  "--macos")
    build_macos
  ;;

  "--ios")
    echo 'ios'
  ;;

  "--android")
    echo 'android'
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
