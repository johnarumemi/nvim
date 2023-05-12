local wk = require("which-key")

wk.register({
	--
	-- <leader>n
	--
	n = { [[:NvimTreeToggle<CR>]], "Toggle Tree" },
	--
	-- <leader>t
	--
	t = {
		name = "Toggle",
		i = { [[:IndentLinesToggle<CR>]], "Indent Lines Toggle" },
		b = { [[:TagbarToggle<CR>]], "Tagbar Toggle" },
	},
}, { prefix = "<leader>" })
