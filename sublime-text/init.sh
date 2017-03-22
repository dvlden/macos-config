#!/usr/bin/env bash

source "$DOT_DIR/lib/functions.sh"

# Should be default on macOS now... but heck, just in case
mkdir -p ~/usr/local/bin

# Symlink binary
symlinkFromTo "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" "/usr/local/bin/subl"

# Store Path
SUBLIME_PATH="$HOME/Library/Application Support/Sublime Text 3"

if [ ! -f "$SUBLIME_PATH/Installed Packages/Package Control.sublime-package" ]; then
    # Close Sublime Text for proper installation of extensions
    osascript -e 'quit app "Sublime Text"'

    # Install Package Control to proper destination
    cd "$SUBLIME_PATH/Installed Packages" && curl -O 'https://packagecontrol.io/Package Control.sublime-package'

    # Symlink Packages
    symlinkFromTo "$DOT_DIR/sublime-text/Package Control.sublime-settings" "$SUBLIME_PATH/Packages/User/Package Control.sublime-settings"

    # Symlink Preferences
    symlinkFromTo "$DOT_DIR/sublime-text/Preferences.sublime-settings" "$DOT_DIR/sublime-text/Preferences.sublime-settings"
fi
