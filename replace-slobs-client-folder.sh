#!/bin/bash
# Script is a work in-progress. Want to backup current slobs-client and swap in a user's slob-client for testing.
# Note: you'll need to either logout or search sl-desktop for "canSync()" and disable syncing to the cloud otherwise your SceneCollection will get overwritten

if [ $# -eq 0 ]; then
  echo "No arguments provided. Please provide the name of the slobs-client folder you wish to copy over"
  echo "Example: ./replace-slobs-client-folder.sh ~/Downloads/2025-05-05T18_57_11.377Z-awesome_streamer"
  exit 1
else
  echo "copying over the contents of the source folder: $1"
fi

# This could use some refinement. It assumes user didnt have a backup already.
cp -R ~/Library/Application\ Support/slobs-client ~/Library/Application\ Support/slobs-client-backup
rm -rf ~/Library/Application\ Support/slobs-client/SceneCollections
#mkdir ~/Library/Application\ Support/slobs-client

# copy the test slobs-client over into ~/Library/Application\ Support/slobs-client 
cp -R $1/SceneCollections/ ~/Library/Application\ Support/slobs-client/SceneCollections
open ~/Library/Application\ Support/slobs-client

