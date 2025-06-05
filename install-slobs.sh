#!/bin/bash

# Build & run the install target for streamlabs-obs. Then Copy it into other projects
origin_dir=$(pwd) # Save the starting directory
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
elif [[ "$ostype" == MINGW* || "$ostype" == CYGWIN* ]]; then
  preset=$1
  buildFolder="build_x64"
  echo "No need to copy bins on $ostype. Building osn wil automatically copy the bins."
  exit 0
else
  echo "Unsupported operating system: $ostype"
  exit 1
fi

echo "Time to run xcodebuild"

cmake --build --target install --preset $preset -v

exit_status=$?

if [ $exit_status -eq 0 ]; then
    # now copy into desktop
    cd $origin_dir
    "./copy-slobs-artifacts.sh"
else
  echo "failed running the install target with exit code $exit_status."
fi

