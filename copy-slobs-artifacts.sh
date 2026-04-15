#!/bin/bash
function display_usage {
  echo "Usage: $(basename "$0")"
  echo ""
  echo "Description: This script copies SLOBS artifacts to Streamlabs Desktop (MacOS only)."
  echo ""
  echo "Options:"
  echo "  -h, --help        Display this help message and exit"
  echo ""
  echo "Examples:"
  echo "  $(basename "$0")"
  echo ""
  echo "Exit Status:"
  echo "  0 on successful execution."
  echo "  1 if obs-studio-node or Desktop folder cannot be found or build failure."
  exit 0
}
if [[ ( "$1" == "--help" ) || ( "$1" == "-h" ) ]]; then
  display_usage
fi

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
  echo "$0 Error: 'obs-studio-node' directory is not found. Build obs-studio-node first."
  exit 1
fi

if [ ! -d "../desktop" ]; then
  echo "$0 Error: 'desktop' directory is not found. Build Streamlabs Desktop first."
  exit 1
fi

# now copy into desktop
rm -rf ../desktop/node_modules/obs-studio-node/Frameworks
rm -rf ../desktop/node_modules/obs-studio-node/Plugins
build_folder="../obs-studio-node/build/libobs-src" # use packed_build - this OBS.app has ffmpeg/ffprobe
echo "Now copying into streamlabs/desktop from $build_folder/OBS.app to ../desktop/node_modules/obs-studio-node"
cp  -Rv "$build_folder/OBS.app/Contents/Frameworks" ../desktop/node_modules/obs-studio-node
cp  -Rv "$build_folder/OBS.app/Contents/Plugins" ../desktop/node_modules/obs-studio-node

# Update the libs stored in OSN.app/distribute/obs-studio-node
distribution_dir=../desktop/node_modules/obs-studio-node/OSN.app/distribute/obs-studio-node
if [ -d "$distribution_dir" ]; then
  cp -Rv "$build_folder/OBS.app/Contents/Frameworks/" "$distribution_dir"/Frameworks/
  echo "Copied updated frameworks to $distribution_dir/Frameworks/"
fi
