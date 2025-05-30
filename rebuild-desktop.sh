cd ../desktop
rm -rf node_modules
yarn install

exit_status=$?

if [ $exit_status -eq 0 ]; then
  echo "built desktop successfully."
  yarn add realm # Hack to work around 'realm' build error
  yarn compile
else
  echo "failed building desktop with exit code $exit_status."
fi


