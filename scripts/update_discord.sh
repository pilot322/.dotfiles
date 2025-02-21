#!/bin/bash

# Define download URL
DOWNLOAD_URL="https://discord.com/api/download?platform=linux&format=deb"

# Temporary download directory
TEMP_DIR="/tmp/discord_update"
mkdir -p "$TEMP_DIR"

# Download Discord
echo "Downloading latest Discord version..."
wget -q -O "$TEMP_DIR/discord.deb" "$DOWNLOAD_URL"

# Install the .deb package
echo "Installing Discord..."
sudo dpkg -i "$TEMP_DIR/discord.deb"

# Fix dependencies if needed
sudo apt-get -f install -y

# Clean up
rm -rf "$TEMP_DIR"

echo "Discord updated successfully!"
