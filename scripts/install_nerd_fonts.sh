#!/bin/bash

# cyan
info() {
    echo -e "\033[0;36m$1\033[0m"
}

# red
error() {
    echo -e "\033[0;31m$1\033[0m"
}

# yellow
warning() {
    echo -e "\033[0;33m$1\033[0m"
}

if [ $# -eq 0 ]; then
    echo "No font names provided"
    exit 1
fi

host_name=$(hostname)

source ~/.local/bin/variables.sh

if [[ " ${SERVER_HOSTS[@]} " =~ " ${host_name} " ]]; then
    warning "This is a server, skipping font installation"
    exit 1
fi

base_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"

os=$(uname)

tmp_dir=$(mktemp -d)

case "$os" in
    "Linux") # For Linux and WSL
        font_dir=~/.local/share/fonts/
        ;;
    "Darwin") # For macOS
        font_dir=~/Library/Fonts/
        ;;
    *)
        error "Unsupported OS: $os"
        exit 1
esac


all_fonts_installed=true

for font in "$@"
do
    font_file=${font// /-}

    if [ -d "$font_dir/$font_file" ]; then
        info "$font Nerd Font is already installed"
        continue
    fi

    all_fonts_installed=false

    info "Downloading $font Nerd Font"

    curl -Lo "$tmp_dir/$font_file.zip" "$base_url/$font_file.zip"

    info "Unzipping $font Nerd Font"

    unzip "$tmp_dir/$font_file.zip" -d "$tmp_dir"

    info "Installing $font Nerd Font"
    
    mkdir -p "$font_dir/$font_file"
    mv "$tmp_dir"/*.ttf "$font_dir/$font_file/"

    info "$font Nerd Font installed"
done

if [ "$all_fonts_installed" == "true" ]; then
    info "All fonts are already installed"
else
    # update the font cache (not necessary on macOS)
    if [ "$os" == "Linux" ]; then
        info "Updating font cache"
        fc-cache -f -v
    fi
    info "All fonts installed successfully"
fi

rm -r "$tmp_dir"
