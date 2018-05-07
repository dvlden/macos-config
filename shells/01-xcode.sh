#!/usr/bin/env bash

echo "=> X Code"

if ! xcode-select --print-path &> /dev/null; then
  print_info "Installing..."

  # create the placeholder file that's checked by CLI updates' .dist code in Apple's SUS catalog
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

  # find the CLI Tools update
  PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')

  # install it
  softwareupdate -i "$PROD" --verbose
  rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

  print_success "Completed..."
else
  print_success "Skipping..."
fi
