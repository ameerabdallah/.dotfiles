#!/bin/bash

# determine OS
os=$(uname)
case "$os" in
    "Linux")
        # For Linux and WSL
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        sudo apt update
        sudo apt install -y eza
        ;;
    "Darwin")
        # For macOS
        brew install eza
        ;;
    *)
        echo "Unsupported OS: $os"
        exit 1
esac

