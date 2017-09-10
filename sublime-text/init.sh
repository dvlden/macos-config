#!/usr/bin/env bash

source "$DOT_DIR/lib/functions.sh"

# Symlink binary
symlinkFromTo "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" "/usr/local/bin/subl"

# Store Path
SUBLIME_PATH=$(echo "$HOME/Library/Application Support/Sublime Text 3")
CLOUD_PATH=$(echo "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Sublime Text 3")

if [ ! -f "$SUBLIME_PATH/Installed Packages/Package Control.sublime-package" ]; then
  echo "Sublime Text: quit..."
  # Close Sublime Text for proper installation of extensions
  osascript -e 'quit app "Sublime Text"'

  echo "Sublime Text: download package-control..."
  # Install Package Control to proper destination
  curl -o "$SUBLIME_PATH/Installed Packages/Package Control.sublime-package" \
          'https://packagecontrol.io/Package Control.sublime-package'
fi

# Remove User folder and then symlink it from iCloud
rm -rf "$SUBLIME_PATH/Packages/User"

symlinkFromTo "$CLOUD_PATH/User" \
              "$SUBLIME_PATH/Packages"
