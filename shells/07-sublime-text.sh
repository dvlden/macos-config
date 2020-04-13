#!/usr/bin/env bash

echo "=> Sublime Text"


DIR=$(echo "$HOME/Library/Application Support/Sublime Text 3")

print_info "Installing package control..."

if [ ! -f "$DIR/Installed Packages/Package Control.sublime-package" ]
then
  osascript -e 'quit app "Sublime Text"'
  # osascript -e 'tell app "Sublime Text" to quit'

  curl -o "$DIR/Installed Packages/Package Control.sublime-package" \
          "https://packagecontrol.io/Package Control.sublime-package"

  osascript -e 'run app "Sublime Text"'
  # osascript -e "tell application \"Sublime Text\" to activate"

  print_success "Completed..."
else
  print_success "Skipping..."
fi
