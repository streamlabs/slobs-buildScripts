#!/bin/bash
# Usage:
# ./build-frontend-desktop-app.sh [--disable | --unset-codesign | --unset-all | --compile | --reload-zshrc]
# Arguments:
# --unset-codesign to remove SLOBS_NO_SIGN environment var so you can run codesign
# --unset-all to remove both SLOBS_NO_NOTARIZE & SLOBS_NO_SIGN environment variables
# --disable to bypass codesign completely (even if you have APPLE_SLD_IDENTITY set in your environment)
# --reload-zshrc: reload env vars from .zshrc
# --compile: runs yarn compile in the desktop folder
# Example: ./build-frontend-desktop-app.sh --unset-all --compile

function display_usage {
  echo "Usage: $(basename "$0") [OPTIONS]"
  echo ""
  echo "Description: This script builds the Streamlabs Desktop.app."
  echo ""
  echo "Options:"
  echo "  -h, --help        Display this help message and exit."
  echo "  --unset-codesign  remove SLOBS_NO_SIGN environment var"
  echo "  --unset-all       remove both SLOBS_NO_NOTARIZE & SLOBS_NO_SIGN environment variables"
  echo "  --disable         bypass codesign completely (even if you have APPLE_SLD_IDENTITY set in your environment)"
  echo "  --reload-zshrc    reload env vars from .zshrc"
  echo "  --compile         runs yarn compile in the desktop folder"
  echo "  --x64             run yarn package:mac which builds for x86_64"
  echo "  --arm64           run yarn package:mac-arm64"
  echo "  -o, --open        run desktop from terminal"
  echo "  -c, --clean       wipe cached node modules"
  echo ""
  echo "Examples:"
  echo "  $(basename "$0") --unset-all --compile"
  echo ""
  echo "Exit Status:"
  echo "  0 on successful execution."
  echo "  1 if Streamlabs desktop folder cannot be found."
  exit 0
}

if [[ ( "$1" == "--help" ) || ( "$1" == "-h" ) ]]; then
  display_usage
  exit 0
fi

if [ ! -d "../desktop" ]; then
  echo "Error: 'desktop' directory is not found."
  exit 1
fi

ARCH=$(uname -m)
shouldOpen=false
shouldClean=false
shouldCompile=false

# function setups codesign/notarize
codesign_app() {
    for arg in "$@"; do
        # The settings below should come from the bash profile ideally.
        if [[ "$arg" == "--disable" ]]; then
            export SLOBS_NO_SIGN="true"
            echo "$0 Set SLOBS_NO_SIGN=true to disable codesign"
        elif [[ "$arg" == "--unset-codesign" ]]; then
            unset SLOBS_NO_SIGN
            echo "$0 unset SLOBS_NO_SIGN env var"
        elif [[ "$arg" == "--unset-all" ]]; then
            unset SLOBS_NO_NOTARIZE
            unset SLOBS_NO_SIGN
            echo "$0 unset SLOBS_NO_SIGN & SLOBS_NO_NOTARIZE env vars"
        fi
    done
}

origin_dir=$(dirname "$(realpath "$0")")
parent_dir=$(dirname "$origin_dir")
app_dir="$parent_dir"/desktop/node_modules/obs-studio-node/OSN.app
found_app=false
"./remove-DSStore.sh" # remove hidden files that will break codesign

if [ -d "$app_dir" ]; then
  echo "backup OSN.app in $app_dir"
  mkdir "$origin_dir"/tmp
  mv $app_dir "$origin_dir"/tmp
  rm -rf $app_dir
  found_app=true
fi



# Search args for reload zsh option
for arg in "$@"; do
  if [ "$arg" == "--reload-zshrc" ]; then
    echo "$0 run source ~/.zshrc"
    source ~/.zshrc
  elif [ "$arg" == "--x64" ]; then
    ARCH="x86_64"
  elif [[ "$arg" == "--arm64" ]]; then
    ARCH="arm64"
  elif [[ "$arg" == "--clean" || "$arg" == "-c" ]]; then
    shouldClean=true
  elif [[ "$arg" == "--open" || "$arg" == "-o" ]]; then
    shouldOpen=true
  elif [ "$arg" == "--compile" ]; then
    shouldCompile=true
  fi
done

codesign_app "$@"

cd "$origin_dir"
cd ../desktop

if [[ "$shouldClean" == true ]]; then
  rm -rf ../desktop/node_modules
  yarn install
  yarn compile
elif [[ "$shouldCompile" == true ]]; then
  echo "$0 run yarn compile"
  yarn compile
fi

# set PYTHON_PATH to get around this issue: https://github.com/electron-userland/electron-builder/issues/6726
echo "$0 searching for python2 to resolve electron-builder issue: https://github.com/electron-userland/electron-builder/issues/6726"
output=$(which python2)
export PYTHON_PATH=$output

rm -rf dist # remove previous artifacts

if [[ "$ARCH" == "arm64" ]]; then
    yarn package:mac-arm64
elif [[ "$ARCH" == "x86_64" ]]; then
    yarn package:mac
else
    echo "$0 Unknown architecture: $ARCH"
fi

if [[ "$found_app" == "true" ]]; then
  echo "Restore $app_dir"
  mv "$origin_dir"/tmp/OSN.app $app_dir
  rm -rf "$origin_dir"/tmp
fi

exit_status=$?
if [ $exit_status -eq 0 ]; then
  if [[ "$shouldOpen" == true ]]; then
    if [[ "$ARCH" == "arm64" ]]; then
        cd dist/mac-arm64
    elif [[ "$ARCH" == "x86_64" ]]; then
        cd dist/mac-x86_64
    fi
    # Run the app directly so we can capture stdout and skip auto-updater
    ./Streamlabs\ Desktop.app/Contents/MacOS/Streamlabs\ Desktop --skip-update --nosync
  fi
fi