-- Utility functions for CopilotChat
--
-- This module provides utility functions for CopilotChat plugin.
--
-- @module jai.plugins.core.ai.copilot-chat.utils

---@class KeyOpts
---@field mapping string Keymap for this command
---@field description string Description displayed in which-key
---@field mode? string Mode for the key mapping (e.g., "n" for normal mode, "x" for visual)
---@field command? string Optional command string to execute (defaults to the CopilotChat command)

---@class CommandConfig
---@field name string Name of the command (without CopilotChat prefix)
---@field enabled? boolean Whether the command is enabled (defaults to true)
---@field builtin? boolean Whether this is a builtin command that doesn't need registration
---@field command? function Function to execute when the command is called
---@field command_opts? table Options passed into nvim_create_user_command
---@field mapping_opts? KeyOpts Options passed into which-key

-- Helper function to create custom commands and register their mappings
---@param config CommandConfig Configuration for creating the custom command
---@return table|nil which-key entry if mapping provided, nil otherwise
local function create_custom_command(config)
  -- Extract values from config with defaults
  local name = config.name
  local builtin = config.builtin or false
  local command = config.command
  local command_opts = config.command_opts or {}
  local mapping_opts = config.mapping_opts

  -- Create the command if not builtin and command function exists
  if not builtin and command ~= nil then
    vim.api.nvim_create_user_command("CopilotChat" .. name, command, command_opts)
  end

  -- Create and return which-key mapping if provided
  if mapping_opts and mapping_opts.mapping then
    local wk_entry = {
      mapping_opts.mapping,
      mapping_opts.command or ("<cmd>CopilotChat" .. name .. "<cr>"),
      desc = mapping_opts.description or ("CopilotChat - " .. name),
    }

    if mapping_opts.mode then
      wk_entry.mode = mapping_opts.mode
    end

    return wk_entry
  end

  return nil
end

return {
  create_custom_command = create_custom_command,
}
