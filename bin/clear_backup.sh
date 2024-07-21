#!/usr/bin/env bash

# Clear all backed up neovim cache and config files

rm -rf $HOME/.local/share/nvim.bak
rm -rf $HOME/.cache/nvim.bak
rm -rf $HOME/.local/state/nvim.bak
