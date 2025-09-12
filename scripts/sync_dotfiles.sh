#!/bin/bash

pushd "$HOME/.dotfiles" || exit
git pull
./install -u
popd || exit
