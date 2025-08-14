#!/bin/bash
if [ ! -d "../obs-studio" ]; then
  echo "Error: 'obs-studio' directory is not found."
  exit 1
fi

if [ ! -d "../obs-studio-node" ]; then
  echo "Error: 'obs-studio-node' directory is not found."
  exit 1
fi

HOME_DIR=$(dirname "$(realpath "$0")")
cd "$HOME_DIR" # start in base folder
cd ..
origin_dir=$(pwd) # Save the starting directory
cd obs-studio/

os="darwin"
preset="macos"
buildFolder="build_macos/packed_build"
openXcode=""

# Determine the operating system
ostype=$(uname)

if [ "$ostype" == "Darwin" ]; then
  echo "$0 is running on macOS."
  rm -rf build_macos
  # Search args for 'yarn compile' option
  for arg in "$@"; do
    if [ "$arg" == "--open" ]; then
      openXcode="open"
    fi
  done
elif [[ "$ostype" == MINGW* || "$ostype" == CYGWIN* ]]; then
  preset="windows-x64"
  buildFolder="$origin_dir/obs-studio-node/build/libobs-src"
  rm -rf build_x64
  os="windows"
else
  echo "Unsupported operating system: $ostype"
  exit 1
fi

cmake --preset $preset -DCMAKE_INSTALL_PREFIX=$buildFolder -DOBS_PROVISIONING_PROFILE="$PROVISIONING_PROFILE" -DOBS_CODESIGN_TEAM="$CODESIGN_TEAM" -DOBS_CODESIGN_IDENTITY="$CODESIGN_IDENT"

if [[ "$os" == "darwin" && "$openXcode" == "open" ]]; then
  # Relaunch Xcode; this way all the targets will be refreshed properly
  echo "Attempting to re-open the xcode project"
  open "build_macos/obs-studio.xcodeproj"
fi
