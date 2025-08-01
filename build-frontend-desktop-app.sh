#!/bin/bash
# Usage: Pass "unset" to remove SLOBS_NO_SIGN environment var so you can run codesign. Pass "disable" to bypass codesign completely (even if you have APPLE_SLD_IDENTITY set in your environment). If no arguments are specified, then no environment variables will be altered.
# Example: ./build-frontend-desktop-app.sh disable
codesign_app() {
    # The settings below should come from the bash profile ideally.
    if [[ "$1" == "disable" ]]; then
        export SLOBS_NO_SIGN="true"
        export APPLE_SLD_IDENTITY="false"
        echo "$0 Set SLOBS_NO_SIGN=true and APPLE_SLD_IDENTITY=false to disable codesign"
    elif [[ "$1" == "unset" ]]; then
        unset SLOBS_NO_SIGN
        echo "$0 unset SLOBS_NO_SIGN env var"
    else
        echo "$0 Unrecognized argument: $1"
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

# set PYTHON_PATH to get around this issue: https://github.com/electron-userland/electron-builder/issues/6726
echo "$0 searching for python2 to resolve electron-builder issue: https://github.com/electron-userland/electron-builder/issues/6726"
output=$(which python2)
export PYTHON_PATH=$output

rm -rf dist # remove previous artifacts

ARCH=$(uname -m)

if [[ "$ARCH" == "arm64" ]]; then
    yarn package:mac-arm64
elif [[ "$ARCH" == "x86_64" ]]; then
    yarn package:mac
else
    echo "$0 Unknown architecture: $ARCH"
fi
