-- [[ telescope ]]
local wk = require("which-key")

wk.register({
	t = {
		name = "Toggle",
		s = { [[:Telescope<CR>]], "Open Telescope" }, -- create finding
	},
	f = {
		name = "Files",
		f = { [[:Telescope find_files<CR>]], "Find File" }, -- create finding
		g = { [[:Telescope live_grep<CR>]], "Grep In Files" }, -- create finding
		b = { [[:Telescope buffers<CR>]], "Buffers" }, -- create finding
		h = { [[:Telescope help_tags<CR>]], "Help Tags" }, -- create finding
	},
}, { prefix = "<leader>" })
