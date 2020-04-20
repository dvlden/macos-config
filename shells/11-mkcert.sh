#!/usr/bin/env bash

echo "=> Generate localhost SSL certificates"

mkcert -install
mkdir -p "$HOME/.ssl"

mkcert localhost 127.0.0.1 ::1
mkcert "*.secure.test"
mkcert "*.secure.public"
