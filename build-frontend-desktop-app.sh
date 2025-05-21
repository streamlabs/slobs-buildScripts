#!/bin/bash
cd ../desktop

# compile source file changes
#yarn compile

# The settings below should come from the bash profile ideally.
#export SLOBS_NO_NOTARIZE=true
#export SLOBS_NO_SIGN=true

ARCH=$(uname -m)

if [[ "$ARCH" == "arm64" ]]; then
    yarn package:mac-arm64
elif [[ "$ARCH" == "x86_64" ]]; then
    yarn package:mac
else
    echo "Unknown architecture: $ARCH"
fi
