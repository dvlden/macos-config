#!/usr/bin/env bash

source "$DOT_DIR/lib/functions.sh"

# Should be default on macOS now... but heck, just in case
mkdir -p ~/usr/local/bin

# Symlink binary
symlinkFromTo "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" "/usr/local/bin/subl"

# Store Path
SUBLIME_PATH="$HOME/Library/Application Support/Sublime Text 3"

if [ ! -f "$SUBLIME_PATH/Installed Packages/Package Control.sublime-package" ]; then
    echo "Sublime Text: quit..."
    # Close Sublime Text for proper installation of extensions
    osascript -e 'quit app "Sublime Text"'

    echo "Sublime Text: download package-control..."
    # Install Package Control to proper destination
    curl -o "$SUBLIME_PATH/Installed Packages/Package Control.sublime-package" \
            'https://packagecontrol.io/Package Control.sublime-package'

    echo "Sublime Text: symlink package-control..."
    # Symlink Packages
    symlinkFromTo "$DOT_DIR/sublime-text/Package Control.sublime-settings" \
                  "$SUBLIME_PATH/Packages/User/Package Control.sublime-settings"

    echo "Sublime Text: symlink preferences..."
    # Symlink Preferences
    symlinkFromTo "$DOT_DIR/sublime-text/Preferences.sublime-settings" \
                  "$SUBLIME_PATH/Packages/User/Preferences.sublime-settings"
fi
