#!/bin/bash
HOME_DIR=$(dirname "$(realpath "$0")")
cd "$HOME_DIR"
"./install-slobs.sh"
exit_status=$?

if [ $exit_status -eq 0 ]; then
  echo "Script slobs-to-desktop executed successfully."
  cd "$HOME_DIR"
  "./install-osn.sh" # run build, install, and finally copy osn distribution -> desktop
else
  echo "building slobs failed with exit code $exit_status."
fi

