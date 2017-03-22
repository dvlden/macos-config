#!/usr/bin/env bash

### Include functions
source "$DOT_DIR/lib/functions.sh"

if ! xcode-select --print-path &> /dev/null; then
    # ask_for_confirmation "Confirm installation of Xcode!"

    # if answer_is_yes; then
        execute "xcode-select --install"
        execute xcode_agree
    # fi
fi

xcode_agree() {
    sleep 1
    sudo osascript <<EOD
        tell application "System Events"
            tell process "Install Command Line Developer Tools"
                keystroke return
                click button "Agree" of window "License Agreement"
            end tell
        end tell
EOD
}
