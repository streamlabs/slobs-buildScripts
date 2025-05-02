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
    rm -rf $origin_dir/desktop/node_modules/obs-studio-node/PlugIns
    cp -R ./Frameworks $origin_dir/desktop/node_modules/obs-studio-node
    cp -R ./PlugIns $origin_dir/desktop/node_modules/obs-studio-node
    cp obs_studio_client.0.3.21.0.node $origin_dir/desktop/node_modules/obs-studio-node
else
  echo "building osn failed with exit code $exit_status."
fi
