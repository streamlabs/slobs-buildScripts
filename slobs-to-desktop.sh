origin_dir=$(pwd) # Save the starting directory
cd ../obs-studio/

echo "Remove old artifacts to ensure they are properly replaced"
rm -rf ./build_macos/packed_build/OBS.app
rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/OBS.app

echo "Time to run xcodebuild"

cmake --build --target install --preset macos -v

exit_status=$?

if [ $exit_status -eq 0 ]; then
    # now copy into desktop
    cd $origin_dir
    "./copy-slobs-artifacts.sh"
else
  echo "failed running the install target with exit code $exit_status."
fi

