-- Set LSP logging level to debug
vim.lsp.set_log_level(vim.log.levels.ERROR)

-- build .spl files
local spell_files = vim.fn.globpath(vim.o.runtimepath, "spell/*.add", false, true)
for _, file in ipairs(spell_files) do
  -- use `silent!` to suppress output messages from command
  vim.cmd("silent! mkspell! " .. vim.fn.fnameescape(file))
end

_G.neorg_env = os.getenv("NEORG_ENVIRONMENT") or "DEFAULT"

-- bootstrap lazy.nvim and plugins
require("jai.config")

vim.debug("neorg environment: " .. _G.neorg_env, { title = "Init" })

-- set colorscheme using custom command
vim.cmd("ColorschemeAuto rose-pine")

local snippet_search = vim.fn.stdpath("config") .. "/snippets"

vim.debug("snippets path: " .. snippet_search, { title = "Init" })

-- Print message if VSCode neovim extension is activated
-- and neovim confing was successfully loaded in VSCode.
if vim.g.vscode then
  print("VSCode neovim extension activated")
end

local platform = JUtil.os

if platform.is_mac() then
  -- macOS specific code
  vim.debug("MacOS platform detected", { title = "Init" })
elseif platform.is_linux() then
  -- Linux specific code
  vim.debug("Linux platform detected", { title = "Init" })
elseif platform.is_windows() then
  -- Windows specific code
  vim.debug("Windows platform detected", { title = "Init" })
end
