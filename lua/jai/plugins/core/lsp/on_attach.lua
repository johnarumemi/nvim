-- [[ used in every lspconfig by default ]]
-- Dependencies: 
-- - which-key

local M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function M.on_attach(client, bufnr)
	-- scope these keybinds to buffer for attached language server
	-- below should only be passed 2 further arguments
	-- NOTE: vim.keymap.set accepts direct lua functions in {rhs} argument.
	-- Underneath, it calls vim.api.nvim_set_keymap approriately

    local wk = require("which-key")

	local function buf_set_keymap(...)
		vim.keymap.set(...)
	end
	-- below should only be passed 3 further arguments
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions

	-- Enable completion triggered by <c-x><c-o>
	-- TODO: is this redundant with the use of nvim_cmp?
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	buf_set_keymap("n", "<space>e", vim.diagnostic.open_float, bufopts)
	buf_set_keymap("n", "[d", vim.diagnostic.goto_prev, bufopts)
	buf_set_keymap("n", "]d", vim.diagnostic.goto_next, bufopts)
	buf_set_keymap("n", "<space>q", vim.diagnostic.setloclist, bufopts)

	buf_set_keymap("n", "gD", vim.lsp.buf.declaration, bufopts)
	buf_set_keymap("n", "gd", vim.lsp.buf.definition, bufopts)
	buf_set_keymap("n", "gi", vim.lsp.buf.implementation, bufopts)
	buf_set_keymap("n", "gr", vim.lsp.buf.references, bufopts)
	buf_set_keymap("n", "K", vim.lsp.buf.hover, bufopts)
	buf_set_keymap("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	buf_set_keymap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	buf_set_keymap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	buf_set_keymap("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	buf_set_keymap("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	buf_set_keymap("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	buf_set_keymap("n", "<space>ca", vim.lsp.buf.code_action, bufopts)

	buf_set_keymap("n", "<space>f", function()
		vim.lsp.buf.format({ async = true })
	end, bufopts)

	wk.register({
		["<space>e"] = { "lsp: open diagnostic float" },
		["[d"] = { "got prev diagnostics" },
		["]d"] = { "got next diagnostics" },
		gD = { "lsp: goto declaration" },
		gd = { "lsp: goto definition" },
		K = { "lsp: hover" },
		gi = { "lsp: goto implementation" },
		gr = { "lsp: references" },
		["<C-k>"] = { "lsp: signature help" },
	}, { buffer = bufnr })

	wk.register({
		wa = { "lsp: add workspace folder" },
		wr = { "lsp: remove workspace folder" },
		wl = { "lsp: list workspace folders" },
		D = { "lsp: type definition" },
		rn = { "lsp: rename" },
		ca = { "lsp: code action" },
		f = { "format" },
	}, { prefix = "<space>", buffer = bufnr })

	--   -- Set some keybinds conditional on server capabilities
	--   if client.server_capabilities.document_formatting then
	--     buf_set_keymap("n", "<space>f", vim.lsp.buf.formatting(), bufopts)
	--   elseif client.server_capabilities.document_range_formatting then
	--     --buf_set_keymap('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
	--     buf_set_keymap("n", "<space>f", vim.lsp.buf.formatting(), bufopts)
	--   end

	-- Show line diagnostics automatically in hover window
	-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-line-diagnostics-automatically-in-hover-window

	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = bufnr,
		callback = function()
			local opts = {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				border = "rounded",
				source = "always",
				prefix = "●",
				scope = "cursor",
			}
			vim.diagnostic.open_float(nil, opts)
		end,
	})
end

return M
