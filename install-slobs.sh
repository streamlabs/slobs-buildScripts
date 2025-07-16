#!/bin/bash

# Build & run the install target for streamlabs-obs. Then Copy it into other projects
origin_dir=$(dirname "$(realpath "$0")")
cd $origin_dir
cd ../obs-studio/

preset="macos"
buildFolder="build_macos"

# Determine the operating system
ostype=$(uname)

if [ "$ostype" == "Darwin" ]; then
  os="darwin"
  echo "preset: $preset"
  echo "Remove old artifacts to ensure they are properly replaced"
  rm -rf ./build_macos/packed_build/OBS.app
  rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/OBS.app
  echo "Time to run xcodebuild"
  cmake --build --target install --preset $preset -v
elif [[ "$ostype" == MINGW* || "$ostype" == CYGWIN* ]]; then
  preset=$1
  buildFolder="build_x64"
  cmake --build build_x64 --target install -v --config RelWithDebInfo
else
  echo "Unsupported operating system: $ostype"
  exit 1
fi

exit_status=$?

if [ $exit_status -eq 0 ]; then
    # now copy into desktop
    cd "$origin_dir"
    "./copy-slobs-artifacts.sh"
else
  echo "failed running the install target with exit code $exit_status."
fi

