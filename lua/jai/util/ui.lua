-- UI Utility Functions
--
-- This module provides UI-related utilities for Neovim.
-- Adapted from LazyVim's UI utility module.
--
-- Usage:
--   local ui = require("jai.util.ui")
--   ui.bufremove(bufnr)
--
-- @module jai.util.ui
-- @copyright 2025
-- @license MIT
-- @see https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/ui.lua

---@class jai.util.ui
local M = {}

---@alias Sign {name:string, text:string, texthl:string, priority:number}

---@param buf number? 
--- Safely remove a buffer while preserving window layout
-- This function attempts to:
-- 1. Use an alternate buffer if available
-- 2. Use a previous buffer if available
-- 3. Create a new buffer as a last resort
-- @param buf number? The buffer number to remove (default: current buffer)
function M.bufremove(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  -- Try to replace the buffer in all windows displaying it
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr("#")
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  
  -- Delete the buffer
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end

return M
