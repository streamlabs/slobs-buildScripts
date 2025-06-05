# Description

This project contains a collection of `bash` scripts that will build various streamlabs projects like streamlabs/obs-studio for Windows/Mac & install it in other projects.
Windows users likely want to run these scripts from _Git Bash_.

# How to use

Install this folder in the same directory right beside streamlabs-desktop, streamlabs-obs-studio, and streamlabs/obs-studio-node. This project contains `bash` scripts

```
root folder (ex., streamlabs folder)
-->slobs-buildScripts (this repo)
-->desktop
-->obs-studio (aka SLOBS)
-->obs-studio-node (aka OSN)
```

Download all of these repos first. Run `rebuild-slobs.sh` to build SLOBS. Next, run `build-osn-streambuild.sh` which will create a fake .app bundle for the automated tests. The advantage here it mimcs what the
github workflow does. _Note_: Xcode currently defaults to Debug for OSN & SLOBS but the build scripts are configured for RelWithDebugInfo. Lastly, run `rebuild-desktop.sh`.

When you make changes to code, just hit _⌘+Shift+B_ (or CTRL+SHIFT+B on Windows in Visual studio code) to copy over the updated artifacts. Sometimes drastic changes may require rebuild which means running `build-osn-streambuild.sh 1`. This will
trigger a complete rebuild of obs-studio-node causing it to redownload all deps. Grab a coffee this might take a few mins.

# Testing SLOBS changes in obs-studio-node

Run `update-everything-from-SLOBS.sh` script (via the _⌘+Shift+B_ hotkey combination) to build `streamlabs/obs-studio` & `obs-studio-node`. The resulting artifacts will be copied into `streamlabs/desktop`. Now when you execute the `yarn run test` command in OSN directory, it will utilize the latest build automatically. In addition, _desktop_ will also be updated.

# Environment variables

If you want to enable mac-virtual-cam on macOS 12.3+ you'll need to define the following environment variable `OBS_CODESIGN_TEAM` to enable automatic codesign in xcode.

# Future plan

Eventually, some of these scripts will likely get copied over into their respective repos where appropriate after I feel like they're in a more polished state
