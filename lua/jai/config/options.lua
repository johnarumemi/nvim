-- Neovim Options Configuration
--
-- This module sets up core Neovim options, organized by category.
-- These options affect the editor's appearance and behavior.
--
-- Options are loaded before the plugin manager to ensure
-- fundamental settings are available when plugins initialize.
--
-- @module jai.config.options
-- @copyright 2025
-- @license MIT

-- alias the vim.opt meta-accessor
local opt = vim.opt

-- [[ Context ]]
opt.number = true -- bool: Show line numbers
opt.relativenumber = false -- bool: Show relative line numbers (relative to position of cursor)
opt.scrolloff = 4 -- int:  Min num lines of context
opt.signcolumn = "yes" -- str:  Show the sign column

-- [[ Filetypes ]]
opt.encoding = "utf8" -- str:  String encoding to use
opt.fileencoding = "utf8" -- str:  File encoding to use

-- [[ Search ]]
opt.ignorecase = true -- bool: Ignore case in search patterns
opt.smartcase = true -- bool: Override ignorecase if search contains capitals
opt.incsearch = true -- bool: Use incremental search
opt.hlsearch = true -- bool: Highlight search matches

-- [[ Whitespace ]]
opt.expandtab = true -- bool: Use spaces instead of tabs
opt.shiftwidth = 4 -- num:  Size of an indent
opt.softtabstop = 4 -- num:  Number of spaces tabs count for in insert mode
opt.tabstop = 4 -- num:  Number of spaces tabs count for

-- [[ Splits ]]
opt.splitright = true -- bool: Place new window to right of current one
opt.splitbelow = true -- bool: Place new window below the current one

-- [[ Global Theme Settings ]]
opt.syntax = "ON" -- str:  Allow syntax highlighting
opt.termguicolors = true -- bool: If term supports ui color then enable
