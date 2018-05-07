#!/usr/bin/env bash

echo "=> Z Shell"


print_info "Installing..."

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  curl -L "http://install.ohmyz.sh" | sh
  print_success "Completed..."
else
  print_success "Skipping..."
fi


print_info "Configuring..."

if ! grep -Fxq "$CONFIGURED_MESSAGE" "$HOME/.zshrc"
then
  echo "
$CONFIGURED_MESSAGE
if [ -f ~/.my-zshrc ]; then
  . ~/.my-zshrc
fi" >> "$HOME/.zshrc"
  print_success "Completed..."
else
  print_success "Skipping..."
fi
