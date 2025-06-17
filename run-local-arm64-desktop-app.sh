#!/bin/bash
# Run Streamlabs Desktop w/o triggering the updater and open the logs folder (although stdout and stderr will appear in Terminal).
HOME_DIR=$(dirname "$(realpath "$0")")
cd "$HOME_DIR" # make sure we start in the home folder
# Reload bash profile etc incase dev changed env variable
source ~/.zshrc

ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    cd ../desktop/dist/mac-arm64  || { echo "Error: Failed to change to directory mac-arm64 make sure the artifact has been built by the yarn package:mac-arm64 command"; exit 1; }
elif [[ "$ARCH" == "x86_64" ]]; then
    cd ../desktop/dist/mac  || { echo "Error: Failed to change to directory mac make sure the artifact has been built by the yarn package:mac command"; exit 1; }
else
    echo "Unknown architecture: $ARCH"
fi

open ~/Library/Application\ Support/slobs-client/node-obs/logs/

# Run the app directly so we can capture stdout and skip auto-updater
./Streamlabs\ Desktop.app/Contents/MacOS/Streamlabs\ Desktop --skip-update

