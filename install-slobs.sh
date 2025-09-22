#!/bin/bash

function display_usage {
  echo "Usage: $(basename "$0") [OPTIONS]"
  echo ""
  echo "Description: This script builds obs-studio."
  echo ""
  echo "Options:"
  echo "  -h, --help        Display this help message and exit"
  echo "  --build           Sets build configuration (e.g., Debug, Release, RelWithDebInfo, MinSizeRel). Default is RelWithDebInfo"
  echo ""
  echo "Examples:"
  echo "  $(basename "$0") --build=Debug"
  echo ""
  echo "Exit Status:"
  echo "  0 on successful execution."
  echo "  1 if obs-studio folder cannot be found or build failure."
  exit 0
}

if [[ ( "$1" == "--help" ) || ( "$1" == "-h" ) ]]; then
  display_usage
fi

# Build & run the install target for streamlabs-obs. Then Copy it into other projects
origin_dir=$(dirname "$(realpath "$0")")
cd $origin_dir
cd ../obs-studio/

preset="macos"
buildFolder="build_macos"
cmake_args=()

# Determine the operating system
ostype=$(uname)

for arg in "$@"
do
  if [[ $arg == --build=* ]]; then
    # Extract the value using parameter expansion
    build_type="${arg#*=}"
    cmake_args+=(--config ${build_type})
  fi
done

if [ "$ostype" == "Darwin" ]; then
  os="darwin"
  echo "preset: $preset"
  echo "Remove old artifacts to ensure they are properly replaced"
  rm -rf ./build_macos/packed_build/OBS.app
  rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/OBS.app

  echo "Time to run xcodebuild"
  cmake --build --target install --preset $preset -v "${cmake_args[@]}"
elif [[ "$ostype" == MINGW* || "$ostype" == CYGWIN* ]]; then
  preset=$1
  buildFolder="build_x64"
  cmake --build build_x64 --target install -v "${cmake_args[@]}"
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

