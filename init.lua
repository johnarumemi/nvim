-- Set LSP logging level to debug
vim.lsp.set_log_level(vim.log.levels.ERROR)

_G.neorg_env = os.getenv("NEORG_ENVIRONMENT") or "DEFAULT"

-- bootstrap lazy.nvim and plugins
require("jai.config")

vim.notify("neorg environment: " .. _G.neorg_env, vim.log.levels.DEBUG, { title = "Init" })

-- set colorscheme using custom command
vim.cmd("ColorschemeAuto rose-pine")

-- Print message if VSCode neovim extension is activated
-- and neovim confing was successfully loaded in VSCode.
if vim.g.vscode then
  print("VSCode neovim extension activated")
end
