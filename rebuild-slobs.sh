cd ../obs-studio/

rm -rf build_macos
cmake --preset macos -DCMAKE_INSTALL_PREFIX=build_macos/packed_build

