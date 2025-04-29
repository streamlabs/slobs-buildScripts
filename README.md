# How to use
Install this folder in the same directory right beside streamlabs-desktop, streamlabs-obs-studio, and streamlabs/obs-studio-node. This project contains `bash` scripts

```
root
-->buildScripts
-->streamlabs/desktop
-->streamlabs/obs-studio folder
-->obs-studio-node
```

# Testing SLOBS changes in obs-studio-node
Run `update-everything-from-SLOBS.sh` script to build slobs & then `obs-studio-node`. Now when you execute the `yarn run test` command in OSN directory, it will utilize the latest build automatically. In addition, *desktop* will also be updated.

