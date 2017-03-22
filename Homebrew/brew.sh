#!/usr/bin/env bash

if [[ ! -f $(which brew) ]]; then
    echo "Installing Homebrew."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew bundle --file="Homebrew/Brewfile"
else
    echo "Homebrew update, upgrade cleanup."
    brew upgrade
    brew update
    brew cleanup
fi
