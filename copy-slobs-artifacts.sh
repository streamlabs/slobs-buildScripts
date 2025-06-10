#!/bin/bash
origin_dir=$(dirname "$(realpath "$0")")
cd $origin_dir
cd ../obs-studio/

# Determine the operating system
ostype=$(uname)

if [ "$ostype" == "Darwin" ]; then
  echo "Script $0 is running on macOS."
elif [[ "$ostype" == MINGW* || "$ostype" == CYGWIN* ]]; then
  echo "$0 has nothing to do on Windows as long as build scripts for SLOBS/OSN are working."
  # TODO: Windows build scripts for SLOBS/OSN should already be copying over the bins.
  #cp  -rv build_x64/rundir/RelWithDebInfo/bin/64bit/* ../desktop/node_modules/obs-studio-node/
  #cp  -rv build_x64/rundir/RelWithDebInfo/obs-plugins/64bit/* ../desktop/node_modules/obs-studio-node/

  # copy the artifacts developer compiled from vstudio
  #cp  -rv build_x64/plugins/obs-browser/RelWithDebInfo/* ../desktop/node_modules/obs-studio-node/
  exit 1
else
  echo "Unsupported operating system: $ostype"
  exit 1
fi

if [ ! -d "../obs-studio-node" ]; then
  echo "Error: 'obs-studio-node' directory is not found. Build obs-studio-node first."
  exit 1
fi

if [ ! -d "../desktop" ]; then
  echo "Error: 'desktop' directory is not found. Build Streamlabs Desktop first"
  exit 1
fi

# now copy into desktop
echo "Now copying into streamlabs/desktop"
rm -rf ../desktop/node_modules/obs-studio-node/Frameworks
rm -rf ../desktop/node_modules/obs-studio-node/Plugins
build_folder= "./build_macos/UI/RelWithDebInfo"
cp  -Rv "$build_folder/OBS.app/Contents/Frameworks" ../desktop/node_modules/obs-studio-node
cp  -Rv "$build_folder/OBS.app/Contents/Plugins" ../desktop/node_modules/obs-studio-node

# copy to OSN
# Disabled removing the previous artifact. This will require Obs-studio-node xcodeproj to be rebuilt because it cant find obs.h
#rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/Frameworks

# make sure old artifacts are removed.
rm -rf ./obs-studio-node/streamlabs-build.app/libobs-src/OBS.app
cp -R "$build_folder/Contents/Frameworks" ../obs-studio-node/streamlabs-build.app/libobs-src/
cp -R "$build_folder" ../obs-studio-node/streamlabs-build.app/libobs-src

# Disabled removing the previous artifact. This will require Obs-studio-node xcodeproj to be rebuilt because it cant find obs.h
#rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/include
#rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/lib
cp  -R ./build_macos/packed_build/include ../obs-studio-node/streamlabs-build.app/libobs-src/
cp  -R ./build_macos/packed_build/lib ../obs-studio-node/streamlabs-build.app/libobs-src/
