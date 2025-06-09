#!/bin/bash
# Usage: Pass true or false to the SLOBS_NO_SIGN. Pass "unset" to bypass codesign. If no arguments are specified, then SLOBS_NO_SIGN env var will not be altered.

codesign_app() {
    # The settings below should come from the bash profile ideally.
    if [[ "$1" == "unset" ]]; then
        unset SLOBS_NO_SIGN
        echo "disabled SLOBS_NO_SIGN env var"
    else
        export SLOBS_NO_SIGN=$1
        echo "Set SLOBS_NO_SIGN=$1"
    fi
}

origin_dir=$(pwd)
"./remove-DSStore.sh" # remove hidden files that will break codesign

cd "$origin_dir"
cd ../desktop

# compile source file changes
yarn compile

if [ $# -ge 1 ]; then
    codesign_app $1
fi

rm -rf dist # remove previous artifacts

echo "If codesign is enabled, you need to change identity."
ARCH=$(uname -m)

if [[ "$ARCH" == "arm64" ]]; then
    yarn package:mac-arm64
elif [[ "$ARCH" == "x86_64" ]]; then
    yarn package:mac
else
    echo "Unknown architecture: $ARCH"
fi
