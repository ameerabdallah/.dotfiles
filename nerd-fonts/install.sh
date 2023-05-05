#!/bin/bash

# check if font names were provided
if [ $# -eq 0 ]; then
    echo "No font names provided"
    exit 1
fi

# base URL for nerd fonts
base_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"

# determine the OS
os=$(uname)

# create temp directory
tmp_dir=$(mktemp -d)

# determine the font directory based on the OS
case "$os" in
    "Linux")
        # For Linux and WSL
        font_dir=~/.local/share/fonts/
        ;;
    "Darwin")
        # For macOS
        font_dir=~/Library/Fonts/
        ;;
    *)
        echo "Unsupported OS: $os"
        exit 1
esac


all_fonts_installed=true

for font in "$@"
do
    # replace spaces with dashes
    font_file=${font// /-}

    echo "$font_dir/$font_file"
    if [ -d "$font_dir/$font_file" ]; then
        echo "$font Nerd Font is already installed"
        continue
    fi

    all_fonts_installed=false

    echo "Downloading $font Nerd Font"

    # download the font
    curl -Lo "$tmp_dir/$font_file.zip" "$base_url/$font_file.zip"

    echo "Unzipping $font Nerd Font"

    # unzip the font
    unzip "$tmp_dir/$font_file.zip" -d "$tmp_dir"

    echo "Installing $font Nerd Font"
    
    mkdir -p "$font_dir/$font_file"
    mv "$tmp_dir"/*.ttf "$font_dir/$font_file/"

    echo "$font Nerd Font installed"
done


if [ "$all_fonts_installed" == "true" ]; then
    echo "All fonts are already installed"
else
    # update the font cache (not necessary on macOS)
    if [ "$os" == "Linux" ]; then
        echo "Updating font cache"
        fc-cache -f -v
    fi
    echo "All fonts installed successfully"
fi

# clear temp directory
rm -r "$tmp_dir"

