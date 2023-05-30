local wk = require("which-key")

wk.register({
	--
	-- <leader>t
	t = {
		name = "Toggle",
		c = { [[:Neorg toggle-concealer<CR>]], "Toggle Neorg Concealer" },
	},
}, { prefix = "<leader>" })

local opts = {
	load = {
		["core.defaults"] = {}, -- Loads default behaviour
		["core.export"] = {}, -- enable export module
		["core.concealer"] = {
			config = {
				dim_code_blocks = {
					-- set to false to prevent concealing
					-- code block tags
					-- conceal = false,
				},
				-- basic, diamond or varied
				icon_presets = "basic",
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
	command = "set conceallevel=3",
})

return {
	opts = opts,
}
