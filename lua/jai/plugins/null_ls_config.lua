-- [[ null-ls setup ]]
-- repo: https://github.com/jose-elias-alvarez/null-ls.nvim

local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = {
		-- Lua
		null_ls.builtins.formatting.stylua, -- An opinionated code formatter for Lua.

		--- JS/TS
		null_ls.builtins.diagnostics.eslint,

		-- Python
		null_ls.builtins.formatting.black,
		null_ls.builtins.diagnostics.flake8,

		-- Other
		null_ls.builtins.completion.spell, -- Spell suggestions completion source.
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
