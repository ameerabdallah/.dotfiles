#!/bin/bash

content=$(cat)

# Check if xclip is installed and copy to X11 clipboard
if command -v xclip > /dev/null; then
    echo -n "$content" | xclip -selection clipboard
fi

# Check if pbcopy is available (macOS) and copy to clipboard
if command -v pbcopy > /dev/null; then
    echo -n "$content" | pbcopy
fi

# Check if win32yank is available (WSL) and copy to Windows clipboard
if command -v win32yank.exe > /dev/null; then
    echo -n "$content" | win32yank.exe -i --crlf
fi
