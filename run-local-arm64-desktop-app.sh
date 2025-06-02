#!/bin/bash
# Run Streamlabs Desktop w/o triggering the updater and open the logs folder (although stdout and stderr will appear in Terminal)

# Reload bash profile etc incase dev changed env variable
source ~/.zshrc

# Assumes artifact was built on arm64
cd ../desktop/dist/mac-arm64  || { echo "Error: Failed to change to directory mac-arm64 make sure the artifact has been built by the yarn package:mac-arm64 command"; exit 1; }

open ~/Library/Application\ Support/slobs-client/node-obs/logs/

# Run the app directly so we can capture stdout and skip auto-updater
./Streamlabs\ Desktop.app/Contents/MacOS/Streamlabs\ Desktop --skip-update

