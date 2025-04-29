echo "Copying files from OSN-streambuild-app to desktop/node_modules"

cd ..
origin_dir=$(pwd) # Save the starting directory
cd obs-studio-node
cmake --build streamlabs-build.app --target install --config RelWithDebInfo

exit_status=$?

if [ $exit_status -eq 0 ]; then
  echo "copying the files."
    cd $origin_dir/obs-studio-node/streamlabs-build.app/distribute/obs-studio-node

    rm -rf $origin_dir/desktop/node_modules/obs-studio-node/bin
    cp -R ./bin $origin_dir/desktop/node_modules/obs-studio-node
    rm -rf $origin_dir/desktop/node_modules/obs-studio-node/Frameworks
    cp -R ./Frameworks $origin_dir/desktop/node_modules/obs-studio-node
    cp obs_studio_client.0.3.21.0.node $origin_dir/desktop/node_modules/obs-studio-node
else
  echo "building osn failed with exit code $exit_status."
fi



# echo "Time to run xcodebuild"
# cd /Users/rosbo/projects/streamlabs/obs-studio-node/streamlabs-build.app

# xcodebuild -project obs-studio-node.xcodeproj -target obs-studio-server -destination "generic/platform=macOS,name=Any Mac" -configuration RelWithDebInfo -parallelizeTargets -hideShellScriptEnvironment build
# cp obs-studio-server/RelWithDebInfo/obs64 ../../desktop/node_modules/obs-studio-node/bin

# echo "Time to run xcodebuild on obs-node-client"
# xcodebuild -project obs-studio-node.xcodeproj -target obs_studio_client -destination "generic/platform=macOS,name=Any Mac" -configuration RelWithDebInfo -parallelizeTargets -hideShellScriptEnvironment build
# cp obs-studio-client/RelWithDebInfo/obs_studio_client.0.3.21.0.node ../../desktop/node_modules/obs-studio-node
# cp obs-studio-client/RelWithDebInfo/obs_studio_client.node ../../desktop/node_modules/obs-studio-node

