---@class jai.util.os
local M = {}

--- Determine if the current platform is macOS/Darwin
-- @return boolean True if running on macOS
function M.is_mac()
  return vim.loop.os_uname().sysname == "Darwin"
end

--- Determine if the current platform is Linux
-- @return boolean True if running on Linux
function M.is_linux()
  return vim.loop.os_uname().sysname == "Linux"
end

--- Determine if the current platform is Windows
-- @return boolean True if running on Windows
function M.is_windows()
  return vim.loop.os_uname().sysname:match("Windows")
    or vim.loop.os_uname().sysname == "Win32"
    or vim.loop.os_uname().sysname == "NT"
end

return M
