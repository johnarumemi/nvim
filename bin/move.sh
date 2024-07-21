#!/usr/bin/env bash

# Move all neovim cache and config files

mv $HOME/.local/share/nvim{,.bak}
mv $HOME/.cache/nvim{,.bak}
mv $HOME/.local/state/nvim{,.bak}

