#!/bin/bash
# Usage: Pass "unset" to remove SLOBS_NO_SIGN environment var so you can run codesign. Pass "disable" to bypass codesign completely (even if you have APPLE_SLD_IDENTITY set in your environment). If no arguments are specified, then no environment variables will be altered.
# Example: ./build-frontend-desktop-app.sh disable
codesign_app() {
    # The settings below should come from the bash profile ideally.
    if [[ "$1" == "disable" ]]; then
        export SLOBS_NO_SIGN="true"
        export APPLE_SLD_IDENTITY="false"
        echo "Set SLOBS_NO_SIGN=true and APPLE_SLD_IDENTITY=false to disable codesign"
    elif [[ "$1" == "unset" ]]; then
        unset SLOBS_NO_SIGN
        echo "unset SLOBS_NO_SIGN env var"
    else
        echo "Unrecognized argument: $1"
    fi
}

origin_dir=$(dirname "$(realpath "$0")")
cd "$origin_dir"
"./remove-DSStore.sh" # remove hidden files that will break codesign

if [ $# -ge 1 ]; then
    codesign_app $1
fi

cd "$origin_dir"
cd ../desktop

# compile source file changes
yarn compile
yarn add electron-builder@23.6.0 # Hack: Get around the "NameError: name 'reload' is not defined" error

rm -rf dist # remove previous artifacts

ARCH=$(uname -m)

if [[ "$ARCH" == "arm64" ]]; then
    yarn package:mac-arm64
elif [[ "$ARCH" == "x86_64" ]]; then
    yarn package:mac
else
    echo "Unknown architecture: $ARCH"
fi
