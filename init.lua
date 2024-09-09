-- Set LSP logging level to debug
vim.lsp.set_log_level("debug")

-- bootstrap lazy.nvim and plugins
require("jai.config")

-- Print message if VSCode neovim extension is activated
-- and neovim confing was successfully loaded in VSCode.
if vim.g.vscode then
  print("VSCode neovim extension activated")
end
