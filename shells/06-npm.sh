#!/usr/bin/env bash

echo "=> NPM"


declare -a PACKAGES=(
  'npm-check-updates'
  'vue-cli'
)

for PACKAGE in "${PACKAGES[@]}"
do
  print_info "Installing - $PACKAGE..."

  if ! npm list -g --depth=0 | grep -q $PACKAGE
  then
    npm install -g $PACKAGE
    print_success "Completed..."
  else
    print_success "Skipping..."
  fi
done
