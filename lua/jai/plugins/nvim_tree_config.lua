local wk = require("which-key")

wk.register({
	--
	-- <leader>n
	--
	n = { [[:NvimTreeToggle<CR>]], "Toggle Tree" },
}, { prefix = "<leader>" })

local opts = {
	view = {
		width = 30,
	},
	update_focused_file = {
		enable = true,
		-- 	update_root = true,
	},
	filters = {
		dotfiles = true,

		custom = { "node_modules", "__pycache__" },
	},
}

require("nvim-tree").setup(opts)
