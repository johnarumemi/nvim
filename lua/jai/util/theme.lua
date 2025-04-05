-- Theme-related utilities and centralized theme configuration
--
-- This module centralizes all theme-related functionality, allowing for
-- consistent theme setup across different environments (standalone, VSCode).
--
-- Usage:
--   require("jai.util.theme").setup()
--   require("jai.util.theme").set_theme("rose-pine")
--
-- @module jai.util.theme
-- @copyright 2025
-- @license MIT

---@class jai.util.theme
local M = {}

-- Default theme to use when no specific theme is requested
M.default_theme = "rose-pine"

-- Default theme for VSCode integration
M.vscode_theme = "rose-pine"

--- Set up the colorscheme based on environment
-- Detects whether running in VSCode and sets appropriate theme
function M.setup()
  local theme = M.default_theme
  
  -- Check if running in VSCode integration mode
  if vim.g.vscode then
    theme = M.vscode_theme
    vim.debug("Running in VSCode mode, using theme: " .. theme, { title = "Theme" })
  else
    vim.debug("Running standalone, using theme: " .. theme, { title = "Theme" })
  end
  
  -- Use the ColorschemeAuto command to set the theme
  -- This ensures our autocommands for theme changes are triggered
  vim.cmd("silent! ColorschemeAuto " .. theme)
end

--- Function to set a specific theme
---@param theme_name string name of the theme to set
function M.set_theme(theme_name)
  if not theme_name or theme_name == "" then
    -- If no theme specified, use the appropriate default based on environment
    if vim.g.vscode then
      theme_name = M.vscode_theme
      vim.debug("No theme specified, using VSCode default: " .. theme_name, { title = "Theme" })
    else
      theme_name = M.default_theme
      vim.debug("No theme specified, using default: " .. theme_name, { title = "Theme" })
    end
  end
  
  vim.cmd("silent! ColorschemeAuto " .. theme_name)
end

return M