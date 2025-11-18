function display_usage {
  echo "Usage: $(basename "$0") [OPTIONS]"
  echo ""
  echo "Description: This script builds obs-studio-node."
  echo ""
  echo "Options:"
  echo "  -h, --help        Display this help message and exit"
  echo "  --build           Sets build configuration (e.g., Debug, Release, RelWithDebInfo, MinSizeRel). Default is RelWithDebInfo"
  echo "  --dsym            Writes *.dSYM files"
  echo ""
  echo "Examples:"
  echo "  $(basename "$0") --build=Debug"
  echo ""
  echo "Exit Status:"
  echo "  0 on successful execution."
  echo "  1 if obs-studio folder cannot be found or build failure."
  exit 0
}

if [[ ( "$1" == "--help" ) || ( "$1" == "-h" ) ]]; then
  display_usage
fi

HOME_DIR=$(dirname "$(realpath "$0")")
cd $HOME_DIR
cd ..
origin_dir=$(pwd) # Save the starting directory
cd obs-studio-node

# Determine the operating system
ostype=$(uname)
cmake_args=()

if [ "$ostype" == "Darwin" ]; then
  echo "Copying files from build to desktop/node_modules/obs-studio-node"
elif [[ "$ostype" == MINGW* || "$ostype" == CYGWIN* ]]; then
  cmake --build build --target install --config RelWithDebInfo
  ret=$?  # Capture the exit status of the build
  exit "$ret"
else
  echo "Unsupported operating system: $ostype"
  exit 1
fi

distribution_dir="$origin_dir"/desktop/node_modules/obs-studio-node/OSN.app/distribute/obs-studio-node

if [ ${#cmake_args[@]} -eq 0 ]; then
  cmake_args+=(--config RelWithDebInfo)
fi

write_dsym=false
for arg in "$@"
do
  if [[ $arg == --build=* ]]; then
    # Extract the value using parameter expansion
    build_type="${arg#*=}"
    cmake_args+=(--config ${build_type})
  elif [[ "$arg" == "--dsym" ]]; then
    write_dsym=true
  fi
done

# Remove previous artifacts. Force timestamps to get updated.
rm -rf "$origin_dir/obs-studio-node/OSN.app/distribute/obs-studio-node"
rm -rf "$origin_dir/obs-studio-node/OSN.app/obs-studio-server/*"

# Build and install into distribute folder.
cmake --build build --target install "${cmake_args[@]}"

if [ ! -d "$distribution_dir" ]; then
  echo "$0 Error: 'OSN.app' directory is not found. Build obs-studio-node first."
  exit 1
fi

exit_status=$?

if [ $exit_status -eq 0 ]; then

  rm -rf $origin_dir/desktop/node_modules/obs-studio-node/bin
  # Copy obs-studio-server binary
  cp -RL "$distribution_dir"/bin "$origin_dir"/desktop/node_modules/obs-studio-node
  cp -v "$distribution_dir"/obs_studio_client.0.3.21.0.node "$origin_dir"/desktop/node_modules/obs-studio-node
  cp -v "$distribution_dir"/package.json "$origin_dir"/desktop/node_modules/obs-studio-node
  cp -v "$distribution_dir"/crashpad_database_util "$origin_dir"/desktop/node_modules/obs-studio-node
  cp -v "$distribution_dir"/crashpad_handler "$origin_dir"/desktop/node_modules/obs-studio-node
  cp -v "$distribution_dir"/crashpad_http_upload "$origin_dir"/desktop/node_modules/obs-studio-node
  # Copy updated javascript files incase the developer locally modified them
  cp "$origin_dir"/obs-studio-node/js/* "$origin_dir"/desktop/node_modules/obs-studio-node

  if [ $write_dsym == true ]; then
    python $HOME_DIR/write-debug-symbols.py $distribution_dir
  fi

else
  echo "building osn failed with exit code $exit_status."
fi
exit "$exit_status"
