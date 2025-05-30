#!/bin/bash
if [ ! -d "../obs-studio" ]; then
  echo "Error: 'obs-studio' directory is not found."
  exit 1
fi

if [ ! -d "../obs-studio-node" ]; then
  echo "Error: 'obs-studio-node' directory is not found."
  exit 1
fi

cd ..
origin_dir=$(pwd) # Save the starting directory
cd obs-studio/

os="darwin"
preset="macos"
buildFolder="build_macos/packed_build"

# Determine the operating system
ostype=$(uname)

if [ "$ostype" == "Darwin" ]; then
  echo "Script $0 is running on macOS."
elif [[ "$ostype" == MINGW* || "$ostype" == CYGWIN* ]]; then
  preset="windows-x64"
  buildFolder="$origin_dir/obs-studio-node/build/libobs-src"
  os="windows"
else
  echo "Unsupported operating system: $ostype"
  exit 1
fi

rm -rf "$buildFolder"
cmake --preset $preset -DCMAKE_INSTALL_PREFIX=$buildFolder -DOBS_PROVISIONING_PROFILE="$OBS_PROVISIONING_PROFILE" -DOBS_CODESIGN_TEAM="$OBS_CODESIGN_TEAM" -DOBS_CODESIGN_IDENTITY="$OBS_CODESIGN_IDENTITY"

if [ "$os" == "darwin" ]; then
  # Relaunch Xcode; this way all the targets will be refreshed properly
  echo "Attempting to re-open the xcode project"
  open "build_macos/obs-studio.xcodeproj"
fi
