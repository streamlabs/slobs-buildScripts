# Description
This project contains a collection of `bash` scripts that will build various streamlabs projects like streamlabs/obs-studio for Windows/Mac & install it in other projects.
Windows users likely want to run these scripts from *Git Bash*.

# How to use
Install this folder in the same directory right beside streamlabs-desktop, streamlabs-obs-studio, and streamlabs/obs-studio-node. This project contains `bash` scripts

```
root
-->buildScripts
-->desktop
-->obs-studio
-->obs-studio-node
```

# Environment variables

If you want to enable mac-virtual-cam on macOS 12.3+ you'll need to define the following environment variable `OBS_CODESIGN_TEAM` to enable automatic codesign in xcode.

# Testing SLOBS changes in obs-studio-node
Run `update-everything-from-SLOBS.sh` script (via the CMD+SHIFT+B hotkey) to build `streamlabs/obs-studio` & `obs-studio-node`. The resulting artifacts will be copied into `streamlabs/desktop`. Now when you execute the `yarn run test` command in OSN directory, it will utilize the latest build automatically. In addition, *desktop* will also be updated.

