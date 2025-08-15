#!/bin/bash

# Usage: rebuild-osn [--clean --arch=ARCH]
# Arguments-
# clean: pass in this argument to delete the cached build for a full rebuild which can take quite awhile. If you do not, then the build will compile really fast if you built it before.
# arch - sets CMAKE_OSX_ARCHITECTURES, arm64 or x86_64
# Warning: OSN cmake process will re-download LibOBS so if you built slobs locally you'll need to reinstall your changes into OSN again.
if [ ! -d "../obs-studio-node" ]; then
  echo "Error: 'obs-studio-node' directory is not found."
  exit 1
fi

cd ..
origin_dir=$(pwd) # Save the starting directory

cd obs-studio-node || { echo "Error: Failed to navigate to obs-studio-node."; exit 1; }

build_macos() {
  # Search args for 'yarn compile' option
  for arg in "$@"; do
    if [ "$arg" == "--clean" ]; then
      echo "$0 Deleting cached build. Grab a coffee!"
      rm -rf streamlabs-build.app
    fi
  done

  cmake_args=()
  for arg in "$@"
  do
    # Check if the argument starts with --arch=
    if [[ $arg == --arch=* ]]; then
      # Extract the value using parameter expansion
      arch_value="${arg#*=}"
      cmake_args+=(-DCMAKE_OSX_ARCHITECTURES=${arch_value})
    fi
  done
  echo "$0 Create streamlabs-build.app/distribute folder"
  mkdir -p streamlabs-build.app/distribute
  cd streamlabs-build.app/distribute
  mkdir obs-studio-node
  cd ..
  yarn install
  # Note: This will download a new libobs_src folder (which contains the packed OBS.app built by SLOBS on github)
  cmake .. -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_INSTALL_PREFIX=$origin_dir/obs-studio-node/streamlabs-build.app/../streamlabs-build.app/distribute/obs-studio-node -DSTREAMLABS_BUILD=OFF -DNODEJS_NAME=iojs -DNODEJS_URL=https://artifacts.electronjs.org/headers/dist -DNODEJS_VERSION=v29.4.3 -DLIBOBS_BUILD_TYPE=release -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_OSX_ARCHITECTURES=arm64 "${cmake_args[@]}" -G Xcode

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
  if [ "$1" == "full" ]; then
    echo "Deleting cached build. Grab a coffee!"
    rm -rf build
  fi

  mkdir -p build
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
  build_macos "$@"
elif [[ "$ostype" == MINGW* || "$ostype" == CYGWIN* ]]; then
  build_windows "$@"
else
  echo "Unsupported operating system: $ostype"
  exit 1
fi

