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
  exit 0
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
build_folder="$(pwd)/build_macos/packed_build" # use packed_build - this OBS.app has ffmpeg/ffprobe
cp  -Rv "$build_folder/OBS.app/Contents/Frameworks" ../desktop/node_modules/obs-studio-node
cp  -Rv "$build_folder/OBS.app/Contents/Plugins" ../desktop/node_modules/obs-studio-node

# copy to OSN

# make sure old artifacts are removed.
rm -rf ./obs-studio-node/streamlabs-build.app/libobs-src/OBS.app
#rm -rf ./obs-studio-node/streamlabs-build.app/libobs-src/Frameworks
cp -RL "$build_folder/OBS.app/Contents/Frameworks" ../obs-studio-node/streamlabs-build.app/libobs-src/
cp -RL "$build_folder/OBS.app" ../obs-studio-node/streamlabs-build.app/libobs-src

cp  -R ./build_macos/packed_build/include ../obs-studio-node/streamlabs-build.app/libobs-src/
cp  -R ./build_macos/packed_build/lib ../obs-studio-node/streamlabs-build.app/libobs-src/
