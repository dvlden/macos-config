#!/usr/bin/env bash

echo "Apache: stop & unload daemon..."
sudo apachectl stop
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null
