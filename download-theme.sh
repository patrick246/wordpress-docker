#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

slug=$1

echo "Generating download link"
plugin_info=$(curl -g -s --fail "https://api.wordpress.org/themes/info/1.1/?action=theme_information&request[slug]=${slug}")
echo "plugin info: $plugin_info"
download_link=$(echo "$plugin_info" | jq -r '.download_link')
echo "Download link: $download_link"
curl -sSL --fail -o "${slug}.zip" "$download_link"
echo "unpacking"
unzip "${slug}.zip"
