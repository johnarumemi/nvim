-- [[ general configs ]]
--
-- Some plugins require minimal setup or keybindings
-- and do not require their own .lua file. Place such
-- configs and keymaps here.

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
