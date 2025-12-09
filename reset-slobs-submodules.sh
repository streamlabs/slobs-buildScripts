# !/bin/bash
# Useful script to reset slobs submodules to a clean state
cd ../obs-studio

rm -rf plugins
rm -rf .git/modules/plugins/win-dshow

git clean -xfd
git submodule foreach --recursive git clean -xfd
git reset --hard
git submodule foreach --recursive git reset --hard
git submodule update --init --recursive
