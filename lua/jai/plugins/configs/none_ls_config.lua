-- [[ null-ls setup ]]
-- repo: https://github.com/jose-elias-alvarez/null-ls.nvim

local null_ls = require("null-ls")

return {

  opts = {
    sources = {
      -- Lua
      -- can get binary installed via using Mason
      null_ls.builtins.formatting.stylua, -- An opinionated code formatter for Lua.

      -- --- JS/TS
      -- we already have eslint via lspconfig
      -- null_ls.builtins.diagnostics.eslint,

      -- Python
      -- can get binaries installed either on your path
      -- or via using Mason
      null_ls.builtins.formatting.black,
      null_ls.builtins.diagnostics.flake8,
      null_ls.builtins.code_actions.gitsigns,
    },
    on_attach = function(client, bufnr)
      -- Enable formatting on sync
      -- https://www.reddit.com/r/neovim/comments/12er016/configuring_autoformatting_using_nullls_and/
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save

      if client.supports_method("textDocument/formatting") then
        local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

        -- vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
            vim.lsp.buf.format({
              bufnr = bufnr,
              -- filter = function(_client)
              --     return _client.name == "null-ls"
              -- end
            })
          end,
        })
      end
    end,
  },
}
