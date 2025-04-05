-- Main Configuration Module Entry Point
--
-- This file loads all configuration components in the correct order.
-- The loading order is important because some components depend on others.
--
-- Order:
-- 1. Options - Core Neovim options
-- 2. Variables - Global and buffer variables
-- 3. Keymaps - Key mappings
-- 4. Commands - Custom commands
-- 5. Autocmds - Autocommands
-- 6. Lazy - Plugin manager (loaded last to ensure options are set first)
--
-- @module jai.config
-- @copyright 2025
-- @license MIT

require("jai.config.options") -- Global options
require("jai.config.vars") -- Global variables
require("jai.config.keymaps") -- Global Keymaps
require("jai.config.commands") -- Custom commands
require("jai.config.autocmds") -- Autocommands

-- Plugin Manager Setup
-- This will also load the plugins and set up the plugin manager.
-- It's important that options is loaded before lazy (for mapleader)
require("jai.config.plugin_manager")
