-- Global Variables Configuration
--
-- This module defines global variables and custom helper functions.
-- It includes key mappings for leader keys, terminal settings,
-- and notification helper functions.
--
-- @module jai.config.vars
-- @copyright 2025
-- @license MIT

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
-- mapleader works across all files you edit in neovim
vim.g.mapleader = ","

-- localleader key is specific to a file type
vim.g.localleader = "\\"

-- vim.g.<variable-name> == vim.api.nvim_set_var(variable-name, ...)
-- where vim.g is a meta-accessor. Others are:
-- vim.g == vim.api.nvim_set_var : sets a global variable
-- vim.o == vim.api.nvim_win_set_var  : sets variables are scoped to a given window
-- vim.b == vim.api.nvim_buf_set_var  : sets variables scoped to a given buffer
-- you can replace 'set' with 'get' or 'del' as well.

-- alias the vim.g meta-accessor. Remember that it is used for setting global variables.
local g = vim.g

-- disable netrw at the very sart of init.lua (strongly advised)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- sets global variable 't_co' to 256, enabling support for 256 colors in
-- whichever terminal emulator you're using to run Neovim.
g.t_co = 256
-- tell Neovim that we are using dark mode for terminal background: can set to 'light' as well.
g.background = "dark"

-- update the packpath via adding additional search path
-- This is where neovim will search for packages
local package_path = vim.fn.stdpath("config") .. "/site"
vim.o.packpath = vim.o.packpath .. "," .. package_path

--- Display a notification with INFO level
---@param msg string Content of the notification to show to the user
---@param opts table|nil Optional parameters (title, etc.)
---@diagnostic disable-next-line: unused-local
function vim.info(msg, opts) -- luacheck: no unused args
  vim.notify(msg, vim.log.levels.INFO, opts)
end

--- Display a notification with DEBUG level
---@param msg string Content of the notification to show to the user
---@param opts table|nil Optional parameters (title, etc.)
---@diagnostic disable-next-line: unused-local
function vim.debug(msg, opts) -- luacheck: no unused args
  vim.notify(msg, vim.log.levels.DEBUG, opts)
end

--- Display a notification with WARN level
---@param msg string Content of the notification to show to the user
---@param opts table|nil Optional parameters (title, etc.)
---@diagnostic disable-next-line: unused-local
function vim.warn(msg, opts) -- luacheck: no unused args
  vim.notify(msg, vim.log.levels.WARN, opts) -- FIXED: Was set to DEBUG level
end

--- Display a notification with ERROR level
---@param msg string Content of the notification to show to the user
---@param opts table|nil Optional parameters (title, etc.)
---@diagnostic disable-next-line: unused-local
function vim.error(msg, opts) -- luacheck: no unused args
  vim.notify(msg, vim.log.levels.ERROR, opts)
end
