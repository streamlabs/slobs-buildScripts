cd ../obs-studio/

echo "Remove old artifacts to ensure they are properly replaced"
rm -rf ./build_macos/packed_build/OBS.app
rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/OBS.app

echo "Time to run xcodebuild"
#xcodebuild -project obs-studio.xcodeproj -target obs-studio -destination "generic/platform=macOS,name=Any Mac" -configuration RelWithDebInfo -parallelizeTargets -hideShellScriptEnvironment build
cmake --build --target install --preset macos -v
# now copy into desktop
echo "Now copying libs"
#cp  ./libobs-opengl/RelWithDebInfo/libobs-opengl.dylib ../../desktop/node_modules/obs-studio-node/Frameworks

# cant copy libobs-- I think I need to copy ovber everything else first
rm -rf ./../desktop/node_modules/obs-studio-node/Frameworks
#cp  -R ./build_macos/UI/RelWithDebInfo/OBS.app/Contents/Frameworks ../desktop/node_modules/obs-studio-node

# copy into desktop
cp  -R ./build_macos/packed_build/OBS.app/Contents/Frameworks ../desktop/node_modules/obs-studio-node
# copy to OSN
rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/Frameworks
cp  -R ./build_macos/packed_build/OBS.app/Contents/Frameworks ../obs-studio-node/streamlabs-build.app/libobs-src/
cp -R ./build_macos/packed_build/OBS.app ../obs-studio-node/streamlabs-build.app/libobs-src

rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/include
rm -rf ../obs-studio-node/streamlabs-build.app/libobs-src/lib
cp  -R ./build_macos/packed_build/include ../obs-studio-node/streamlabs-build.app/libobs-src/
cp  -R ./build_macos/packed_build/lib ../obs-studio-node/streamlabs-build.app/libobs-src/
