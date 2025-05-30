#!/bin/bash
cd ../obs-studio/

# Determine the operating system
ostype=$(uname)

if [ "$ostype" == "Darwin" ]; then
  echo "Script $0 is running on macOS."
elif [[ "$ostype" == MINGW* || "$ostype" == CYGWIN* ]]; then
  echo "$0 is copying slobs artifacts to desktop"
  baseDir=$(pwd)
  cp  -rv build_x64/rundir/RelWithDebInfo/bin/64bit/* ../desktop/node_modules/obs-studio-node/
  cp  -rv build_x64/rundir/RelWithDebInfo/obs-plugins/64bit/* ../desktop/node_modules/obs-studio-node/
  exit 1
else
  echo "Unsupported operating system: $ostype"
  exit 1
fi

# now copy into desktop
echo "Now copying into streamlabs/desktop"
rm -rf ./../desktop/node_modules/obs-studio-node/Frameworks
cp  -R ./build_macos/packed_build/OBS.app/Contents/Frameworks ../desktop/node_modules/obs-studio-node
#cp  -R ./build_macos/packed_build/OBS.app/Contents/Library ../desktop/node_modules/obs-studio-node

# copy to OSN
# Disabled removing the previous artifact. This will require Obs-studio-node xcodeproj to be rebuilt because it cant find obs.h
#rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/Frameworks
cp -R ./build_macos/packed_build/OBS.app/Contents/Frameworks ../obs-studio-node/streamlabs-build.app/libobs-src/
cp -R ./build_macos/packed_build/OBS.app ../obs-studio-node/streamlabs-build.app/libobs-src

# Disabled removing the previous artifact. This will require Obs-studio-node xcodeproj to be rebuilt because it cant find obs.h
#rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/include
#rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/lib
cp  -R ./build_macos/packed_build/include ../obs-studio-node/streamlabs-build.app/libobs-src/
cp  -R ./build_macos/packed_build/lib ../obs-studio-node/streamlabs-build.app/libobs-src/
