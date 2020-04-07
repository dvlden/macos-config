#!/usr/bin/env bash

echo "=> Backup restore"

CLOUD_DIR=$(echo "$HOME/Library/Mobile Documents/com~apple~CloudDocs")

cp "$CLOUD_DIR/_mackup/.mackup.cfg" "$HOME"
mackup restore
