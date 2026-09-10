#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q helix | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/helix.png
export DESKTOP=/usr/share/applications/Helix.desktop
export URUNTIME_PRELOAD=1
export STARTUPWMCLASS=helix


# Deploy dependencies
quick-sharun \
  /usr/bin/helix \
  /usr/lib/helix
# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage 
