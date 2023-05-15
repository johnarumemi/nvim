-- [[ Mason and nvim-lspconfig setup]]

require("mason").setup()
require("mason-lspconfig").setup({
  -- mason will also automatically install these LSP servers
  -- if they are not present on your computer
  ensure_installed = { "jsonls" },
  -- if a server is configured in lsp, this will ensure that mason
  -- installs the necessary LSP server
  automatic_installation = true,
})
