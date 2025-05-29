#!/bin/bash

"./slobs-to-desktop.sh"
exit_status=$?

if [ $exit_status -eq 0 ]; then
  echo "Script slobs-to-desktop executed successfully."
  "./copy-osn-to-desktop.sh"
else
  echo "building slobs failed with exit code $exit_status."
fi

   
