#!/usr/bin/env bash

if [[ ! -f $(which brew) ]]; then
    source "$DOT_DIR/apache/before-brew.sh"

    echo "Homebrew: install..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo "Homebrew: bundle..."
    # brew unlink php70
    brew bundle --file="Homebrew/Brewfile"

    source "$DOT_DIR/apache/after-brew.sh"
else
    echo "Homebrew: upgrade, update & cleanup..."
    brew upgrade
    brew update
    brew cleanup
fi
