-- Core library functions for generic operations
--
-- This module provides utility functions for common operations that
-- don't fit elsewhere in the utility structure.
--
-- Usage:
--   local lib = require("jai.util.lib")
--   local plugins = lib.merge_plugin_tables({module1, module2})
--
-- @module jai.util.lib
-- @copyright 2025
-- @license MIT

---@class jai.util.lib
local M = {}

--- Merge multiple plugin tables into a single table
--- This function takes a list of plugin module tables and merges them
--- into a single flat table of plugins, without external dependencies.
---@param modules table[] List of plugin module tables to merge
---@return table[] Flattened table of all plugins
function M.merge_plugin_tables(modules)
  local result = {}

  for _, module in ipairs(modules) do
    -- If the module is a table, add its elements to the result table
    if type(module) == "table" then
      for _, plugin in ipairs(module) do
        table.insert(result, plugin)
      end
    end
  end

  return result
end

return M
