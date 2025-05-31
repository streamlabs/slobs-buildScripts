#!/bin/bash
# Run Streamlabs Desktop w/o triggering the updater and open the logs folder (although stdout and stderr will appear in Terminal)

# Reload bash profile etc incase dev changed env variable
source ~/.zshrc
cd ../desktop/dist/mac-arm64
#cd ./Streamlabs\ Desktop.app/Contents/MacOS
open ~/Library/Application\ Support/slobs-client/node-obs/logs/

# open ./Streamlabs\ Desktop.app --args skip-update

# Run the app directly so we can capture stdout and skip auto-updater
./Streamlabs\ Desktop.app/Contents/MacOS/Streamlabs\ Desktop --skip-update

