#!/bin/bash
origin_dir=$(pwd) # Save the starting directory

"./install-slobs.sh"
exit_status=$?

if [ $exit_status -eq 0 ]; then
  echo "Script slobs-to-desktop executed successfully."
  cd $origin_dir
  "./copy-osn-to-desktop.sh"
else
  echo "building slobs failed with exit code $exit_status."
fi

   

