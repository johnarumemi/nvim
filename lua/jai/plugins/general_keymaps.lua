-- [[ general configs ]]
--
-- Some plugins require minimal setup or keybindings
-- and do not require their own .lua file. Place such
-- configs and keymaps here.
local wk = require("which-key")

wk.register({
	--
	-- <leader>t
	t = {
		name = "Toggle",
		b = { [[:TagbarToggle<CR>]], "Tagbar Toggle" },
	},
}, { prefix = "<leader>" })

-- Disabling conceal for JSON and Markdown without disabling indentLine plugin
vim.g.vim_json_conceal = 0
vim.g.markdown_syntax_conceal = 0
