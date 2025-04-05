-- Plugin Manager Configuration
--
-- This module sets up the lazy.nvim plugin manager and loads plugin specifications.
-- It's loaded last in the configuration sequence to ensure that all options
-- and variables are properly set before plugins are loaded.
--
-- @module jai.config.plugin_manager
-- @copyright 2025
-- @license MIT

-- Bootstrap lazy.nvim if it's not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- NOTE: Below must be done after initial bootstrap of lazy above

-- Load the utility module (but avoid setting it as a global)
local util = require("jai.util")

-- For backward compatibility during refactoring
-- This will be removed once all references to _G.JUtil are updated
_G.JUtil = util

-- Loads plugin specs
require("lazy").setup("jai.plugins.core", {
  defaults = {
    -- Default to true and then manually fix broken plugins
    lazy = true,
  },
  install = {
    missing = true,
  },
  change_detection = {
    notify = false,
  },
})