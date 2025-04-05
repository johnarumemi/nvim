-- Global Keyboard Mappings Configuration
--
-- This module defines custom keyboard mappings for Neovim.
-- It includes helper functions for mapping keys and various keybindings for
-- different editor operations.
--
-- @module jai.config.keymaps
-- @copyright 2025
-- @license MIT

-- Helper function for setting keymaps with common options
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Open url/path under cursor
-- [[
-- We have to glue together a string made up of the literal '!open ' and
-- the result of running shellescape. Since the map command family takes
-- all its arguments as literals we need to use the execute command. It
-- allows us to execute a string as if we had typed it on the command-line.
-- This string does not have to be a literal, it can be a variable, the result
-- of a function call, or something glued together.
-- In general if we want to execute a command which has be be assembled on the
-- fly we must use the execute command to do so.
-- ]]
map("", "gx", [[:silent execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]], {})

-- remap the key used to leave insert mode
-- map has 4 parameters:
-- 1. mode: the mode you want the key bind to apply
--    insert mode
--    normal mode
--    command mode
--    visual mode
--
-- 2. Sequence: The sequence of keys to press
-- 3. Command: The command you want the keypresses to execute
-- 4. Options: an optional Lua table of options to configure (silent or noremap)
map("i", "jk", "<Esc>", {})
map("i", "jj", "<Esc>", {})
-- keymap is available in insert mode
-- sequence is 'jk'
-- the 'escape command' (returning us to normal mode) is called
-- no additional options configured here, pass in an empty table
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
