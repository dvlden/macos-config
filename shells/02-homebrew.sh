#!/usr/bin/env bash

echo "=> Homebrew"

if [[ ! -f $(which brew) ]]
then
  print_info "Installing..."

  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew bundle --file="$ROOT_DIR/core/Brewfile"
  brew cleanup && brew upgrade && brew update && brew doctor

  print_success "Completed..."
else
  print_success "Skipping..."
fi
