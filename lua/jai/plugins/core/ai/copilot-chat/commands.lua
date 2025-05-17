-- Custom commands for CopilotChat
local utils = require("jai.plugins.core.ai.copilot-chat.utils")

-- Function to define and register all custom commands
---@param chat table CopilotChat module
---@param select table CopilotChat.select module
---@param context table CopilotChat.context module
---@return table Table of which-key mapping entries
local function create_custom_commands(chat, select, context)
  local commands = {
    -- Command: CopilotChatVisual
    -- Description: Ask Copilot about the current visual selection
    -- Usage: :'<,'>CopilotChatVisual [prompt]
    Visual = {
      func = function(args)
        chat.ask(args.args, { selection = select.visual })
      end,
      command_opts = { nargs = "*", range = true },
      mapping_opts = nil, -- No default mapping
    },

    -- Command: CopilotChatBuffer
    -- Description: Ask Copilot about the entire current buffer
    -- Usage: :CopilotChatBuffer [prompt]
    Buffer = {
      func = function(args)
        chat.ask(args.args, { selection = select.buffer })
      end,
      command_opts = { nargs = "*", range = true },
      -- no default mapping, but this command may be used by other
      -- commands that have a mapping
      mapping_opts = {},
    },

    -- Command: CopilotChatInline
    -- Description: Shows Copilot's response in a floating window near the cursor
    -- Usage: :'<,'>CopilotChatInline [prompt]
    -- Mapping: <leader>ax (visual mode)
    Inline = {
      func = function(args)
        chat.ask(args.args, {
          selection = select.visual,
          window = {
            layout = "float",
            relative = "cursor",
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end,
      command_opts = { nargs = "*", range = true },
      mapping_opts = {
        mapping = "<leader>ax",
        description = "Inline chat",
        mode = "x",
      },
    },

    -- Command: CopilotChatReset
    -- Description: Clears the chat history and buffer
    -- Usage: :CopilotChatReset
    -- Mapping: <leader>al
    Reset = {
      func = function() end, -- Just use the built-in command
      command_opts = { nargs = 0 },
      mapping_opts = {
        mapping = "<leader>al",
        description = "Clear buffer and chat history",
      },
    },

    -- Command: CopilotChatToggle
    -- Description: Toggles the Copilot Chat panel
    -- Usage: :CopilotChatToggle
    -- Mapping: <leader>ta
    Toggle = {
      func = function() end, -- Just use the built-in command
      command_opts = { nargs = 0 },
      mapping_opts = {
        mapping = "<leader>ta",
        description = "Toggle",
      },
    },
  }

  local mappings = {}

  -- Register all commands and collect mappings
  for name, cmd_def in pairs(commands) do
    local mapping = utils.create_custom_command(name, cmd_def.func, cmd_def.command_opts, cmd_def.mapping_opts)

    if mapping then
      table.insert(mappings, mapping)
    end
  end

  return mappings
end

return {
  create_custom_commands = create_custom_commands,
}

