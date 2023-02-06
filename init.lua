--[[ init.lua ]]

-- IMPORTS
-- as well as the init.lua file, Neovim will also look for files 
-- that are included in the /lua subdirectory. All code contained 
-- in this subfolder is part of the runtimepath and can be
-- imported for use in Neovim with the below commands:
require('jai.vars')      -- Variables from ./lua/vars.lua file
require('jai.opts')      -- Options
require('jai.keys')      -- Keymaps
require('jai.plugins')   -- Plugins

-- PLUGINS
-- Add these sections after you have updated 
-- plugins.lua and run PackerInstall
-- TODO: move setup of each plugin to separate file
require('nvim-tree').setup{}
require("jai.themes.main")
require('nvim-autopairs').setup{}


-- Setup LSP related plugins
require("jai.mason")
require("jai.lsp")          -- requires jai.mason
require("jai.rust")         -- requires jai.mason
require("jai.nvim_cmp_config")   -- requires jai.rust (TODO: confirm dependency)

-- It is advised that the below is commented out until core plugins all installed
require("jai.treesitter")
