cd ..
origin_dir=$(pwd) # Save the starting directory
cd obs-studio-node

# Determine the operating system
ostype=$(uname)

if [ "$ostype" == "Darwin" ]; then
  echo "Copying files from OSN-streambuild-app to desktop/node_modules"
elif [[ "$ostype" == MINGW* || "$ostype" == CYGWIN* ]]; then
  cmake --build . --target install --config RelWithDebInfo
  ret=$?  # Capture the exit status of the build
  exit "$ret"
else
  echo "Unsupported operating system: $ostype"
  exit 1
fi

# Remove previous artifacts. Force timestamps to get updated.
rm -rf "$origin_dir/obs-studio-node/streamlabs-build.app/distribute/obs-studio-node"
rm -rf "$origin_dir/obs-studio-node/streamlabs-build.app/obs-studio-server/RelWithDebInfo"

# Build RelWithDebInfo artifact and install into distribute folder.
cmake --build streamlabs-build.app --target install --config RelWithDebInfo

exit_status=$?

if [ $exit_status -eq 0 ]; then
  distribution_dir="$origin_dir/obs-studio-node/streamlabs-build.app/distribute/obs-studio-node"

  rm -rf $origin_dir/desktop/node_modules/obs-studio-node/bin
  # Copy obs-studio-server binary
  cp -Rv "$distribution_dir/bin" "$origin_dir/desktop/node_modules/obs-studio-node"
  cp -v "$distribution_dir/obs_studio_client.0.3.21.0.node" "$origin_dir/desktop/node_modules/obs-studio-node"
else
  echo "building osn failed with exit code $exit_status."
fi
exit "$exit_status"
