-- Neovim Configuration Entry Point
--
-- This is the main entry point for the Neovim configuration. It:
-- 1. Sets up basic environment settings
-- 2. Loads the main configuration modules
-- 3. Initializes theme and platform-specific settings
--
-- @copyright 2025
-- @license MIT

-- Set LSP logging level
vim.lsp.set_log_level(vim.log.levels.ERROR)

-- build .spl files
local spell_files = vim.fn.globpath(vim.o.runtimepath, "spell/*.add", false, true)
for _, file in ipairs(spell_files) do
  -- use `silent!` to suppress output messages from command
  vim.cmd("silent! mkspell! " .. vim.fn.fnameescape(file))
end

_G.neorg_env = os.getenv("NEORG_ENVIRONMENT") or "DEFAULT"

-- bootstrap neovim configuration using the `init.lua` file in below directory:
-- ~/.config/nvim/lua/jai/config/init.lua
require("jai.config")

vim.debug("neorg environment: " .. _G.neorg_env, { title = "Init" })

-- Initialize theme settings (centralized theme configuration)
require("jai.util.theme").setup()

local snippet_search = vim.fn.stdpath("config") .. "/snippets"

vim.debug("snippets path: " .. snippet_search, { title = "Init" })

-- Print message if VSCode neovim extension is activated
-- and neovim confing was successfully loaded in VSCode.
if vim.g.vscode then
  vim.info("VSCode neovim extension activated")
end

-- Initialize platform-specific settings
require("jai.util.platform").setup()
