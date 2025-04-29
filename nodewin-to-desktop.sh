cd ../node-window-rendering/build
cmake --build . --target install --config RelWithDebInfo 
cp -R dist/* ../../desktop/node_modules/node-window-rendering
