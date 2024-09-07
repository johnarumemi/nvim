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

  local group_name = "Git Hunk"

  -- Actions: Normal & Visual Mode
  wk.add({
    {
      mode = { "n", "v" },
      { "<leader>h", buffer = bufnr, group = group_name },
      { "<leader>hr", ":Gitsigns reset_hunk<CR>", buffer = bufnr, desc = "Reset Hunk" },
      { "<leader>hs", ":Gitsigns stage_hunk<CR>", buffer = bufnr, desc = "Stage Hunk" },
    },
  })

  -- Actions: Normal Mode
  wk.add({
    mode = { "n" },
    -- { "<leader>h", buffer = bufnr, group = group_name },
    { "<leader>hu", gs.undo_stage_hunk, buffer = bufnr, desc = "Undo Stage Hunk" },
    { "<leader>hS", gs.stage_buffer, buffer = bufnr, desc = "Stage Buffer" },
    { "<leader>hR", gs.reset_buffer, buffer = bufnr, desc = "Reset Stage Buffer" },
    { "<leader>hp", gs.preview_hunk, buffer = bufnr, desc = "Preview Hunk" },
    {
      "<leader>hb",
      function()
        gs.blame_line({ full = true })
      end,
      buffer = bufnr,
      desc = "Blame Line",
    },
    { "<leader>hd", gs.diffthis, buffer = bufnr, desc = "Diff This Hunk" },
    {
      "<leader>hD",
      function()
        gs.diffthis("~")
      end,
      buffer = bufnr,
      desc = "Diff This ~",
    },
    {
      { "<leader>ht", buffer = bufnr, group = "Toggle" },
      { "<leader>htb", gs.toggle_current_line_blame, buffer = bufnr, desc = "Current Line Blame" },
      { "<leader>htd", gs.toggle_deleted, buffer = bufnr, desc = "Deleted" },
    },
  })

  wk.add({
    { "[c", buffer = bufnr, desc = "Prev Hunk" },
    { "]c", buffer = bufnr, desc = "Next Hunk" },
  })

  -- Text object: contains actual mapping
  wk.add({
    { "hi", ":<C-U>Gitsigns select_hunk<CR>", buffer = bufnr, desc = "Select Hunk", mode = { "o", "x" } },
  })
end

config.on_attach = on_attach

return {

  config = config,
}
