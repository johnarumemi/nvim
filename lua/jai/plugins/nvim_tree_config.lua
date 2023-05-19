local wk = require("which-key")

wk.register({
	--
	-- <leader>n
	--
	n = { [[:NvimTreeToggle<CR>]], "Toggle Tree" },
}, { prefix = "<leader>" })

local opts = {
	update_focused_file = {
		enable = true,
		update_root = true,
	},
}

require("nvim-tree").setup(opts)
