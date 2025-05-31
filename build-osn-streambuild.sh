#!/bin/bash
cd ..
origin_dir=$(pwd) # Save the starting directory

cd obs-studio-node || { echo "Error: Failed to navigate to obs-studio-node."; exit 1; }

build_macos() {

  rm -rf streamlabs-build.app
  mkdir -p streamlabs-build.app/distribute
  cd streamlabs-build.app/distribute
  mkdir obs-studio-node
  cd ..
  cmake .. -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_INSTALL_PREFIX=$origin_dir/obs-studio-node/streamlabs-build.app/../streamlabs-build.app/distribute/obs-studio-node -DSTREAMLABS_BUILD=OFF -DNODEJS_NAME=iojs -DNODEJS_URL=https://artifacts.electronjs.org/headers/dist -DNODEJS_VERSION=v29.4.3 -DLIBOBS_BUILD_TYPE=release -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_OSX_ARCHITECTURES=arm64 -G Xcode

  exit_status=$?

  if [ "$exit_status" -eq 0 ]; then
    echo "built obs-studio-node successfully."
    cd ..
    cmake --build streamlabs-build.app --target install --config RelWithDebInfo
  else
    echo "failed building obs-studio-node with exit code $exit_status."
    exit 1
  fi
}

build_windows() {
  echo "Script $0 is running on Windows.."
  mkdir build
  yarn install
  cd build
  cmake -G "Visual Studio 17 2022" -A x64 -DCMAKE_PREFIX_PATH="$origin_dir/obs-studio-node/build/libobs-src/" ../ -DCMAKE_INSTALL_PREFIX="$origin_dir/desktop/node_modules/obs-studio-node"
  

  exit_status=$?

  if [ "$exit_status" -eq 0 ]; then
    echo "Built obs-studio-node successfully."
    cmake --build . --target install --config RelWithDebInfo
  else
    echo "failed building obs-studio-node with exit code $exit_status."
    exit 1
  fi
}

# Determine the operating system
ostype=$(uname)

code=0

if [ "$ostype" == "Darwin" ]; then
  echo "Script is building obs-studio-node within streamlabs-build.app."
  build_macos
elif [[ "$ostype" == MINGW* || "$ostype" == CYGWIN* ]]; then
  build_windows
else
  echo "Unsupported operating system: $ostype"
  exit 1
fi

