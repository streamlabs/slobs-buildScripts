#!/usr/bin/env bash

function display_usage {
  echo "Usage: $(basename "$0") [OPTIONS]"
  echo ""
  echo "Description: Kill all running Electron processes. Useful when the test harness crashes and leaves Electron popups behind."
  exit 0
}

if [[ ( "$1" == "--help" ) || ( "$1" == "-h" ) ]]; then
  display_usage
  exit 0
fi

# Kill all running Electron processes. Useful when the test harness crashes
# and leaves Electron popups behind.
pkill -9 -f Electron
pkill -9 -f electron
echo "Done."
