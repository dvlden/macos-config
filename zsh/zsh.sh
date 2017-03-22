#!/usr/bin/env bash

### Include functions
source "$DOT_DIR/lib/functions.sh"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing oh-my-zsh"
    curl -L 'http://install.ohmyz.sh' | sh
fi

symlinkDot 'zsh/my-zshrc.symlink'

if ! grep -q "# My zshrc config" "$HOME/.zshrc"; then
    echo "
# My zshrc config
if [ -f ~/.my-zshrc ]; then
    . ~/.my-zshrc
fi" >> "$HOME/.zshrc"
fi
