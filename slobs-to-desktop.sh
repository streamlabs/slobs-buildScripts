cd ../obs-studio/

echo "Remove old artifacts to ensure they are properly replaced"
rm -rf ./build_macos/packed_build/OBS.app
rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/OBS.app

echo "Time to run xcodebuild"

cmake --build --target install --preset macos -v

exit_status=$?

if [ $exit_status -eq 0 ]; then
    # now copy into desktop
    echo "Now copying into streamlabs/desktop"
    rm -rf ./../desktop/node_modules/obs-studio-node/Frameworks
    cp  -R ./build_macos/packed_build/OBS.app/Contents/Frameworks ../desktop/node_modules/obs-studio-node
    cp  -R ./build_macos/packed_build/OBS.app/Contents/Library ../desktop/node_modules/obs-studio-node

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
else
  echo "failed running the install target with exit code $exit_status."
fi

