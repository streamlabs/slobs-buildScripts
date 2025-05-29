#!/bin/bash
cd ..
origin_dir=$(pwd) # Save the starting directory

cd obs-studio-node
rm -rf streamlabs-build.app
mkdir -p streamlabs-build.app/distribute
cd streamlabs-build.app/distribute
mkdir obs-studio-node
cd ..
cmake .. -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DCMAKE_INSTALL_PREFIX=$origin_dir/obs-studio-node/streamlabs-build.app/../streamlabs-build.app/distribute/obs-studio-node -DSTREAMLABS_BUILD=OFF -DNODEJS_NAME=iojs -DNODEJS_URL=https://artifacts.electronjs.org/headers/dist -DNODEJS_VERSION=v29.4.3 -DLIBOBS_BUILD_TYPE=release -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_OSX_ARCHITECTURES=arm64 -G Xcode

exit_status=$?

if [ $exit_status -eq 0 ]; then
  echo "built obs-studio-node successfully."
  cd ..
  cmake --build streamlabs-build.app --target install --config RelWithDebInfo
else
  echo "failed building obs-studio-node with exit code $exit_status."
fi


