origin_dir=$(pwd) # Save the starting directory
cd ../obs-studio/

preset="macos"
buildFolder="build_macos"
if [ "$1" == "windows-x64" ] || [ "$1" == "windows-ci-x64" ]; then
  preset=$1
  buildFolder="build_x64"
else
  os="darwin"
  echo "preset: $preset"
  echo "Remove old artifacts to ensure they are properly replaced"
  rm -rf ./build_macos/packed_build/OBS.app
  rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/OBS.app
fi

echo "Time to run xcodebuild"

cmake --build --target install --preset $preset -v

exit_status=$?

if [ $exit_status -eq 0 ]; then
    # now copy into desktop
    cd $origin_dir
    "./copy-slobs-artifacts.sh"
else
  echo "failed running the install target with exit code $exit_status."
fi

