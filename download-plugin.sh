#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

slug=$1

download_link=$(curl -s --fail "https://api.wordpress.org/plugins/info/1.0/${slug}.json" | jq -r '.download_link')
curl -sSL --fail -o "$slug.zip" "$download_link"
unzip "$slug.zip"
