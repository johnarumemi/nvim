-- Core Utility Functions
--
-- This module provides core utility functions for the Neovim configuration.
-- It serves as a central hub for utility functions and automatically loads
-- utility submodules on demand using a metatable.
--
-- Usage:
--   local util = require("jai.util")
--   util.dump_to_string(some_table)
--   util.ui.bufremove(0)  -- automatically loads the ui module
--
-- @module jai.util
-- @copyright 2025
-- @license MIT

-- Utility functions from the lazy package manager plugin
local LazyUtil = require("lazy.core.util")

---@class jai.util
---@field ui jai.util.ui
---@field os jai.util.os
---@field platform jai.util.platform
---@field theme jai.util.theme
local M = {}

-- Set up dynamic module loading via metatable
setmetatable(M, {
  __index = function(t, k)
    -- Check if the key is in LazyUtil
    -- and return value if key is found.
    if LazyUtil[k] then
      return LazyUtil[k]
    end

    --- Load the module if it exists, and cache it.
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("jai.util." .. k)
    return t[k] -- return the loaded module
  end,
})

--- Convert any Lua value to a human-readable string representation
-- Especially useful for debugging tables.
-- Use with ':messages' to view the output.
---@param o any The value to convert to string
---@return string The string representation of the value
function M.dump_to_string(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. M.dump_to_string(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

--- Remove and return a value from a table
---@param tbl table The table to modify
---@param key string The key to remove
---@return function The removed value
function M.pop(tbl, key)
  local element = tbl[key]
  tbl[key] = nil
  return element
end

--- Get the options for a plugin
---@param name string The plugin name
---@return table The plugin options
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

--- Get a plugin by name
---@param name string The plugin name
---@return table|nil The plugin definition or nil if not found
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

--- Get the full path to a plugin directory or file
---@param name string The plugin name
---@param path string? Optional path within the plugin directory
---@return string|nil The full path or nil if plugin not found
function M.get_plugin_path(name, path)
  local plugin = M.get_plugin(name)
  path = path and "/" .. path or ""
  return plugin and (plugin.dir .. path)
end

--- Check if a plugin exists
---@param plugin string The plugin name
---@return boolean True if the plugin exists
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

--- Process arguments for a command
---@param config {args?:string[]|fun():string[]?}
---@return table The processed config
function M.get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
    return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
  end
  return config
end

return M
