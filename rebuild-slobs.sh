#!/bin/bash
cd ../obs-studio/

platform="macos"
buildFolder="build_macos"
if [ "$1" == "windows-x64" ] || [ "$1" == "windows-ci-x64" ]; then
  platform=$1
  buildFolder="build_x64"
else
  echo "platform: $platform"
fi

rm -rf $buildFolder
cmake --preset $platform -DCMAKE_INSTALL_PREFIX=$buildFolder/packed_build -DOBS_PROVISIONING_PROFILE="$OBS_PROVISIONING_PROFILE" -DOBS_CODESIGN_TEAM="$OBS_CODESIGN_TEAM" -DOBS_CODESIGN_IDENTITY="$OBS_CODESIGN_IDENTITY"

