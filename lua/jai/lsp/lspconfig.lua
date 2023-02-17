-- [[ LSP Setup ]]
-- setup all your LSP servers here. Ensure that you have required lspconfig first
-- Note: rust_analyzer is setup via rust-tools, so do not perform any setup
-- functionality here for rust.
-- TODO: can this be scoped to a buffer specific option?
local opt = vim.opt

local on_attach = require("jai.lsp.on_attach")
local capabilities = require("jai.lsp.capabilities")

-- Some LSP's are setup via other plugins:
-- rust: setup by rust-tools. see jai/rust.lua for setup configuration

-- After setting up mason-lspconfig you may set up servers
-- via lspconfig
-- Note: this means setup client configurations against a lsp server
-- after all, lspconfig is just a collection of configurations.
-- the below accesses the rust_analyzer configurtion and calls it
-- setup{} function, which wraps around the lsp.start_client() function.

-- Lua
-- mason package name = lua-language-server
require("lspconfig").lua_ls.setup({
	on_attach = function(client, bufnr)
		-- apply default on_attach settings
		on_attach(client, bufnr)

		-- update options for lua files
		opt.shiftwidth = 2 -- num:  Size of an indent
		opt.softtabstop = 2 -- num:  Number of spaces tabs count for in insert mode
		opt.tabstop = 2 -- num:  Number of spaces tabs count for
	end,
	capabilities = capabilities,
})

-- Python
require("lspconfig").pyright.setup({
	on_attach = function(client, bufnr)
		-- apply default on_attach settings
		on_attach(client, bufnr)

		-- update options for lua files
		opt.shiftwidth = 4 -- num:  Size of an indent
		opt.softtabstop = 4 -- num:  Number of spaces tabs count for in insert mode
		opt.tabstop = 4 -- num:  Number of spaces tabs count for
	end,
	capabilities = capabilities,
})

-- SQL
require("lspconfig").sqlls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Markdown
require("lspconfig").marksman.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").eslint.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "EslintFixAll",
		})
	end,
})
