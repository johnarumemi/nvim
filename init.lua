-- Set LSP logging level to debug
vim.lsp.set_log_level(vim.log.levels.INFO)

-- bootstrap lazy.nvim and plugins
require("jai.config")

-- set colorscheme using custom command
vim.cmd("ColorschemeAuto catppuccin-mocha")

-- Print message if VSCode neovim extension is activated
-- and neovim confing was successfully loaded in VSCode.
if vim.g.vscode then
  print("VSCode neovim extension activated")
end
