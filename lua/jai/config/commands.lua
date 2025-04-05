-- Custom Commands Configuration
--
-- This module defines custom Neovim commands.
-- It includes the ColorschemeAuto command to handle theme changes
-- and trigger the appropriate autocommands.
--
-- @module jai.config.commands
-- @copyright 2025
-- @license MIT

-- Create a global variable to store the colorscheme name
vim.g.colorscheme_name = "auto"

--- Function handler for the ColorschemeAuto command
-- This sets the theme and ensures all autocommands are triggered
-- @param opts table Command options containing the theme name
local function fn_colorscheme_auto(opts)
  local notify_title = "Cmd - ColorschemeAuto"

  vim.g.colorscheme_name = opts.args

  vim.notify("Setting terminal colorscheme to " .. opts.args, vim.log.levels.DEBUG, { title = notify_title })

  vim.cmd("colorscheme " .. opts.args)

  vim.notify("Completed setting colorscheme to " .. opts.args, vim.log.levels.DEBUG, { title = notify_title })
end

-- Register the ColorschemeAuto command
-- Usage: ColorschemeAuto <colorscheme>
vim.api.nvim_create_user_command("ColorschemeAuto", fn_colorscheme_auto, {
  nargs = 1,
  complete = "color",
})
