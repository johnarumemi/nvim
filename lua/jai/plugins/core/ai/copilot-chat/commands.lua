-- Custom commands for CopilotChat
--
-- This module provides custom commands for CopilotChat and their keybindings.
--
-- @module jai.plugins.core.ai.copilot-chat.commands

local utils = require("jai.plugins.core.ai.copilot-chat.utils")

-- Function to define and register all custom commands
---@param chat table CopilotChat module
---@param select table CopilotChat.select module
---@param context table CopilotChat.context module
---@return table Table of which-key mapping entries
local function create_copilotchat_commands(chat, select, context)
  -- Table of command configurations
  ---@type CommandConfig[]
  local commands = {
    -- Command: CopilotChatBuffer
    -- Description: Ask Copilot about the entire current buffer
    -- Usage: :CopilotChatBuffer [prompt]
    {
      name = "Buffer",
      enabled = true,
      command = function(args)
        chat.ask(args.args, { selection = select.buffer })
      end,
      command_opts = { nargs = "*", range = true },
      -- no default mapping, but this command may be used by other
      -- commands that have a mapping defined.
      mapping_opts = nil,
    },

    -- Command: CopilotChatToggle
    -- Description: Toggles the Copilot Chat panel
    -- Usage: :CopilotChatToggle
    -- Mapping: <leader>ta
    {
      name = "Toggle",
      enabled = true,
      builtin = true,
      mapping_opts = {
        mapping = "<leader>at",
        description = "Toggle Copilot Chat Visual (V2)",
      },
    },
  }

  local mappings = {}

  -- Register all commands and collect mappings
  for _, cmd_config in ipairs(commands) do
    if cmd_config.enabled ~= false then -- Default to enabled if not specified
      local mapping = utils.create_custom_command(cmd_config)

      if mapping then
        table.insert(mappings, mapping)
      end
    end
  end

  return mappings
end

return {
  create_custom_commands = create_copilotchat_commands,
}
