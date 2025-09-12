#!/bin/bash

pushd "$HOME/.dotfiles" || exit
git pull
pushd "nvim-config" || exit
echo "Checking nvim-config for uncommitted changes..."
if [ -n "$(git status --porcelain)" ]; then
    read -rp $'nvim-config has uncommitted changes... Stash these changes? (y/N)\n' choice
    echo
    case "$choice" in
        y|Y ) echo "Resetting uncommitted nvim-config changes";git stash -a;;
        n|N|"" ) echo "Skipping nvim-config fetch";;
        * ) echo "Invalid" || exit 1 || return 1;;
    esac
fi
popd || exit
./install -u
popd || exit
