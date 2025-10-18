return {
  {
    -- repo: https://github.com/pmizio/typescript-tools.nvim
    "pmizio/typescript-tools.nvim",
    -- Disable in VS Code as it has its own TypeScript LSP support
    enabled = function()
      return not vim.g.vscode
    end,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    config = function()
      require("typescript-tools").setup({
        ---@diagnostic disable-next-line: unused-local
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        settings = {
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      })
    end,
  },
}
