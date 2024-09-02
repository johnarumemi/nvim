-- [[ utility purposes only ]]

-- Utility functions from the lazy package manager plugin
local LazyUtil = require("lazy.core.util")

---@class jai.util
---@field ui jai.util.ui
local M = {}

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

-- dump a table into a string, useful for debugging.
-- use ':messages' to view printed out table.
---@param o any
---@return string
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

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param name string
---@param path string?
function M.get_plugin_path(name, path)
  local plugin = M.get_plugin(name)
  path = path and "/" .. path or ""
  return plugin and (plugin.dir .. path)
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

---@param config {args?:string[]|fun():string[]?}
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
