#!/usr/bin/env bash

source "$DOT_DIR/lib/functions.sh"

# Symlink binary
symlinkFromTo "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" "/usr/local/bin/subl"

# Store Path
SUBLIME_PATH=$(echo "$HOME/Library/Application Support/Sublime Text 3")

if [ ! -f "$SUBLIME_PATH/Installed Packages/Package Control.sublime-package" ]; then
  echo "Sublime Text: quit..."
  # Close Sublime Text for proper installation of extensions
  osascript -e 'quit app "Sublime Text"'

  echo "Sublime Text: download package-control..."
  # Install Package Control to proper destination
  curl -o "$SUBLIME_PATH/Installed Packages/Package Control.sublime-package" \
          'https://packagecontrol.io/Package Control.sublime-package'
fi

# Symlink Packages
symlinkFromTo "$DOT_DIR/sublime-text/Package Control.sublime-settings" \
              "$SUBLIME_PATH/Packages/User/Package Control.sublime-settings"

# Symlink Preferences
symlinkFromTo "$DOT_DIR/sublime-text/Preferences.sublime-settings" \
              "$SUBLIME_PATH/Packages/User/Preferences.sublime-settings"

# Symlink settings
symlinkFromTo "$DOT_DIR/sublime-text/settings/" \
              "$SUBLIME_PATH/Packages/User/"

# Symlink snippets
symlinkFromTo "$DOT_DIR/sublime-text/snippets/" \
              "$SUBLIME_PATH/Packages/User/"
