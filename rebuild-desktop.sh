cd ../desktop
corepack enable
rm -rf node_modules
yarn cache clean
yarn install

exit_status=$?

if [ $exit_status -eq 0 ]; then
  if [ "$ostype" == "Darwin" ]; then
    if [ ! -d "node_modules/electron/dist/Electron.app/Contents/MacOS/Electron" ]; then
      echo "$0 Info: 'Electron.app' is not found running 'node node_modules/electron/install.js'"
      node node_modules/electron/install.js
    fi
  fi
  yarn compile
  if [ "$ostype" == "Darwin" ]; then
    yarn rebuild deasync
  fi
  echo "Finished building at $(date +"%Y-%m-%d %H:%M:%S")"
else
  echo "failed building desktop with exit code $exit_status."
fi
