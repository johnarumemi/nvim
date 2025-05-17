-- Utility functions for CopilotChat

-- Helper function to create custom commands and register their mappings
---@param name string The name of the command (without CopilotChat prefix)
---@param func function The function to execute when the command is called
---@param command_opts table Options for nvim_create_user_command
---@param mapping_opts table|nil Options for which-key registration (mapping, description, mode)
---@return table|nil which-key entry if mapping provided, nil otherwise
local function create_custom_command(name, func, command_opts, mapping_opts)
  vim.api.nvim_create_user_command("CopilotChat" .. name, func, command_opts)

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
