local wk = require("which-key")

local opts = {
	load = {
		["core.defaults"] = {}, -- Loads default behaviour
		["core.export"] = {}, -- enable export module
		["core.completion"] = { -- interface with different completion engines
			config = {
				engine = "nvim-cmp",
			},
		},
		["core.summary"] = {}, -- Creates links to all files in any workspace
		["core.export.markdown"] = {
			config = {
				extensions = "all",
			},
		},
		["core.concealer"] = {
			config = {
				-- basic, diamond or varied
				icon_preset = "basic",
				icons = {
					code_block = {
						conceal = true,
					},
				},
			},
		}, -- Adds pretty icons to your documents
		["core.dirman"] = { -- Manages Neorg workspaces
			config = {
				workspaces = {
					notes = "~/neorg-notes/notes",
					rust = "~/neorg-notes/rust",
					cs = "~/neorg-notes/cs",
				},
				default_workspace = "notes",
			},
		},
		["core.presenter"] = {
			config = {
				zen_mode = "zen-mode",
			},
		},
	},
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.norg" },
	-- command = "set conceallevel=3",
	desc = "Set conceallevel to 3 on entering a norg file",
	callback = function(id, event, group, match, buf, file, data)
		vim.cmd("set conceallevel=3")

		-- update options for current buffer only
		-- num:  Size of an indent
		vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
		--  num:  Number of spaces tabs count for in insert mode
		vim.api.nvim_buf_set_option(0, "softtabstop", 2)
		-- num:  Number of spaces tabs count for
		vim.api.nvim_buf_set_option(0, "tabstop", 2)

		wk.register({
			--
			-- <leader>t
			t = {
				name = "Toggle",
				c = { [[:Neorg toggle-concealer<CR>]], "Toggle Neorg Concealer" },
			},
		}, { prefix = "<leader>" })
	end,
})

-- Use internal formatting for bindings like gq.
vim.api.nvim_create_autocmd("LspAttach", {
	pattern = { "*.norg" },
	callback = function(args)
		vim.bo[args.buf].formatexpr = nil
	end,
})

return {
	opts = opts,
}
