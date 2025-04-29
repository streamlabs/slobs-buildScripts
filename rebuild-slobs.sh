cd ../obs-studio/

rm -rf build_macos
cmake -DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.2.sdk --preset macos -DCMAKE_INSTALL_PREFIX=build_macos/packed_build

