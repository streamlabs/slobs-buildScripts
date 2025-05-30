#!/bin/bash
origin_dir=$(pwd) # Save the starting directory

"./slobs-to-desktop.sh"
exit_status=$?

if [ $exit_status -eq 0 ]; then
  echo "Script slobs-to-desktop executed successfully."
  cd $origin_dir
  "./copy-osn-to-desktop.sh"

  cd $origin_dir
  pwd
  # OSN downloads a slobs artifact stomping LibOBS. So we will overwrite the libOBS with our latest local code.
  "./copy-slobs-artifacts.sh"
else
  echo "building slobs failed with exit code $exit_status."
fi

   

