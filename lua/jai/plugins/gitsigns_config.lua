-- [[ gitsigns configuration ]]

local wk = require("which-key")

local config = {
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	yadm = {
		enable = false,
	},
}

-- Keymaps
local function on_attach(bufnr)
	local gs = package.loaded.gitsigns

	local function map(mode, l, r, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	end

	-- Navigation
	map("n", "]c", function()
		if vim.wo.diff then
			return "]c"
		end
		vim.schedule(function()
			gs.next_hunk()
		end)
		return "<Ignore>"
	end, { expr = true })

	map("n", "[c", function()
		if vim.wo.diff then
			return "[c"
		end
		vim.schedule(function()
			gs.prev_hunk()
		end)
		return "<Ignore>"
	end, { expr = true })

	-- Actions: Normal & Visual Mode
	map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
	map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")

	-- Actions: Normal Mode
	map("n", "<leader>hS", gs.stage_buffer)
	map("n", "<leader>hu", gs.undo_stage_hunk)
	map("n", "<leader>hR", gs.reset_buffer)
	map("n", "<leader>hp", gs.preview_hunk)
	map("n", "<leader>hb", function()
		gs.blame_line({ full = true })
	end)
	-- Below conflics with TagbarToggle keymap
	-- map('n', '<leader>tb', gs.toggle_current_line_blame)
	map("n", "<leader>hd", gs.diffthis)
	map("n", "<leader>hD", function()
		gs.diffthis("~")
	end)
	map("n", "<leader>td", gs.toggle_deleted)

	-- which-key configuration
	wk.register({
		h = {
			name = "Hunk",
			s = { "Stage Hunk" },
			r = { "Reset Hunk" },
			u = { "Undo Stage Hunk" },
			S = { "Stage Buffer" },
			R = { "Reset Stage Buffer" },
			p = { "Preview Hunk" },
			b = { "Blame Line" },
			d = { "Diff This Hunk" },
			D = { "Diff This ~" },
			td = { "Toggle Deleted" },
		},
	}, { prefix = "<leader>", mode = "n", buffer = bufnr })

	wk.register({
		["[c"] = { "Prev Hunk" },
		["]c"] = { "Next Hunk" },
	}, { buffer = bufnr })

	-- Text object: contains actual mapping
	wk.register({
		h = {
			i = { ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk" },
		},
	}, { mode = { "o", "x" }, buffer = bufnr })

	print("gitsigns: on_attach executed...")
end

config.on_attach = on_attach

return {
	config = config,
}
