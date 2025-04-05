-- Platform-specific initialization and utilities
-- Consolidates platform-specific code that was previously in init.lua
--
-- This module provides platform detection and initialization for different operating systems.
-- Usage:
--   require("jai.util.platform").setup()
--
-- @module jai.util.platform
-- @copyright 2025
-- @license MIT

---@class jai.util.platform
local M = {}

-- Reference to the OS detection utility
local os_util = require("jai.util.os")

--- Initialize platform-specific settings
-- Detects the current platform and calls the appropriate setup function
function M.setup()
  if os_util.is_mac() then
    -- macOS specific initialization
    vim.debug("MacOS platform detected", { title = "Platform" })
    M.setup_macos()
  elseif os_util.is_linux() then
    -- Linux specific initialization
    vim.debug("Linux platform detected", { title = "Platform" })
    M.setup_linux()
  elseif os_util.is_windows() then
    -- Windows specific initialization
    vim.debug("Windows platform detected", { title = "Platform" })
    M.setup_windows()
  end
end

--- macOS-specific setup
-- Configure settings specific to macOS systems
function M.setup_macos()
  -- Add macOS-specific settings here
  -- Examples:
  -- - Setting macOS-specific clipboard options
  -- - Configuring macOS-specific paths
  -- - Setting up macOS terminal integration
end

--- Linux-specific setup
-- Configure settings specific to Linux systems
function M.setup_linux()
  -- Add Linux-specific settings here
  -- Examples:
  -- - Setting Linux-specific clipboard options
  -- - Configuring Linux-specific paths
end

--- Windows-specific setup
-- Configure settings specific to Windows systems
function M.setup_windows()
  -- Add Windows-specific settings here
  -- Examples:
  -- - Setting Windows-specific clipboard options
  -- - Configuring Windows-specific paths
  -- - Setting up PowerShell integration
end

return M