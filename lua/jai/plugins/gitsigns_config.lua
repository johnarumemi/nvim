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

	local group_name = "hunk"

	-- Actions: Normal & Visual Mode
	wk.register({
		h = {
			name = group_name,
			s = { ":Gitsigns stage_hunk<CR>", "Stage Hunk" },
			r = { ":Gitsigns reset_hunk<CR>", "Reset Hunk" },
		},
	}, { prefix = "<leader>", mode = { "n", "v" }, buffer = bufnr })

	-- Actions: Normal Mode
	wk.register({
		h = {
			group_name = group_name,
			u = { gs.undo_stage_hunk, "Undo Stage Hunk" },
			S = { gs.stage_buffer, "Stage Buffer" },
			R = { gs.reset_buffer, "Reset Stage Buffer" },
			p = { gs.preview_hunk, "Preview Hunk" },
			b = {
				function()
					gs.blame_line({ full = true })
				end,
				"Blame Line",
			},
			d = { gs.diffthis, "Diff This Hunk" },
			D = {
				function()
					gs.diffthis("~")
				end,
				"Diff This ~",
			},
			t = {
				name = "Toggle",
				b = { gs.toggle_current_line_blame, "Current Line Blame" },
				d = { gs.toggle_deleted, "Deleted" },
			},
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
