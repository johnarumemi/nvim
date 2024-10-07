-- [[ none-ls setup ]]
-- repo: https://github.com/nvimtools/none-ls.nvim
-- based on null-ls.nvim [deprecated]
--
-- sources: https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
-- configuring sources: https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md

local none_ls = require("null-ls")

return {

  opts = {
    sources = {
      -- Lua
      -- can get binary installed via using homebrew, see README.md
      -- An opinionated code formatter for Lua.
      none_ls.builtins.formatting.stylua.with({
        column_width = 100,
      }),

      -- yamlfmt from google
      -- Moved to using conform
      -- null_ls.builtins.formatting.yamlfmt,

      none_ls.builtins.diagnostics.yamllint,

      -- --- JS/TS
      -- we already have eslint via lspconfig
      -- null_ls.builtins.diagnostics.eslint,

      -- Python
      -- can get binaries installed either on your path
      -- or via using Mason
      -- null_ls.builtins.formatting.black,
      none_ls.builtins.code_actions.gitsigns,

      -- NOTE: if you have the below builtin source enabled, it will
      -- also populate nvim-cmp completion window with all
      -- spelling suggestions. This can add alot of noise to the
      -- autocompletion and I suggest disabling it for now, until
      -- we can find a way to reduce the noise from this.
      --
      -- Use the builtin spellchecker instead via:
      -- `:set spell` -> disable via `set nospell`
      -- `unset spell`
      -- `noset spell`
      --
      -- null_ls.builtins.completion.spell,
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
