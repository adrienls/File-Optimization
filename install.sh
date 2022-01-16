#!/bin/sh

# Install needed dependencies
sudo apt update
sudo apt install --yes ghostscript optipng jpegoptim

# Download opti shell script
curl -O https://raw.githubusercontent.com/adrienls/File-Optimization/main/opti.sh

# Add script to path
filePath="/home/$USER/.local/bin/opti"
mv opti.sh "$filePath"

# Give the necessary rights to the script
chmod 500 "$filePath"

