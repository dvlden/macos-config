#!/usr/bin/env bash

echo "=> Sublime Text"


DIR=$(echo "$HOME/Library/Application Support/Sublime Text 3")
# CLOUD_DIR=$(echo "$HOME/Library/Mobile Documents/com~apple~CloudDocs")


print_info "Installing package control..."

if [ ! -f "$DIR/Installed Packages/Package Control.sublime-package" ]
then
  osascript -e 'quit app "Sublime Text"'

  curl -o "$DIR/Installed Packages/Package Control.sublime-package" \
          "https://packagecontrol.io/Package Control.sublime-package"

  print_success "Completed..."
else
  print_success "Skipping..."
fi


# print_info "Symlinking User directory..."

# rm -rf "$DIR/Packages/User"
# symlink_from_to "$CLOUD_DIR/Sublime-Text" "$DIR/Packages/User"
