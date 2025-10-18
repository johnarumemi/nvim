-- Neovim Configuration Entry Point
--
-- This is the main entry point for the Neovim configuration. It:
-- 1. Sets up basic environment settings
-- 2. Loads the main configuration modules
-- 3. Initializes theme and platform-specific settings
--
-- @copyright 2025
-- @license MIT

-- Set verbose level for debugging (0 = off, 1 = some messages, higher = more messages)
-- Uncomment the lines below to enable verbose logging
-- vim.o.verbose = 1

-- Set minimum log level for notifications
-- TRACE=0, DEBUG=1, INFO=2, WARN=3, ERROR=4
-- This filters early messages before nvim-notify plugin loads
-- After nvim-notify loads, it uses its own filtering via the 'level' option
_G.min_log_level = vim.log.levels.INFO

-- Temporarily override vim.notify to filter early messages
-- Once nvim-notify loads, it will replace this with its own implementation
do
  local original_notify = vim.notify
  vim.notify = function(msg, level, opts)
    level = level or vim.log.levels.INFO
    if level >= _G.min_log_level then
      original_notify(msg, level, opts)
    end
  end
end

-- Set LSP logging level
vim.lsp.set_log_level(vim.log.levels.INFO)

_G.is_nix_env = os.getenv("NIX_ENV") ~= nil

-- bootstrap neovim configuration using the `init.lua` file in below directory:
-- ~/.config/nvim/lua/jai/config/init.lua
require("jai.config")

-- Initialize theme settings (centralized theme configuration)
require("jai.util.theme").setup()

local snippet_search = vim.fn.stdpath("config") .. "/snippets"

vim.debug("snippets path: " .. snippet_search, { title = "Init" })

-- Print message if VSCode neovim extension is activated
-- and neovim confing was successfully loaded in VSCode.
if JUtil.is_vscode() then
  vim.info("VSCode neovim extension activated")
else
  -- build .spl files
  local spell_files = vim.fn.globpath(vim.o.runtimepath, "spell/*.add", false, true)
  for _, file in ipairs(spell_files) do
    vim.cmd("silent! mkspell! " .. vim.fn.fnameescape(file))
  end
end

-- Initialize platform-specific settings
require("jai.util.platform").setup()
