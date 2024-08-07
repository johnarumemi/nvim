-- my custom augroups
local function augroup(name)
  return vim.api.nvim_create_augroup("jai_" .. name, { clear = true })
end

--[[
-- Autocommand for git linewraps to occur at
-- set line length
--]]
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = augroup("gitcommit_linewrap"),
  pattern = { "COMMIT_EDITMSG" },
  desc = "Setup gitcommit linewraps",
  callback = function()
    vim.cmd("set conceallevel=3")
    vim.cmd("set wrap")
    vim.cmd("set textwidth=55")
    -- vim.cmd("colorscheme terafox")

    -- update options for current buffer only
    -- num:  Size of an indent
    vim.api.nvim_set_option_value("shiftwidth", 2, { buf = 0 })
    --  num:  Number of spaces tabs count for in insert mode
    vim.api.nvim_set_option_value("softtabstop", 2, { buf = 0 })
    -- num:  Number of spaces tabs count for
    vim.api.nvim_set_option_value("tabstop", 2, { buf = 0 })
  end,
})

--[[
-- Autocommand for setting concealcursor within norg files
--
-- see docs for info,
-- docs: https://neovim.io/doc/user/options.html#'concealcursor'
--
-- For a value of "nc", so long as you are moving around text is concealed, but
-- when starting to insert text or selecting a Visual area the concealed text
-- is displayed, so that you can see what you are doing.
--]]
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = augroup("norg_concealcursor"),
  desc = "Set norg concealcursor to nc",
  callback = function(opts)
    if vim.bo[opts.buf].filetype == "norg" then
      vim.cmd("set cocu=nc")
    end
  end,
})

-- [[ The below were copied from LazyVim's `autocmds.lua` file ]]
-- This file is automatically loaded by lazyvim.config.init.

local function lazy_augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = lazy_augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = lazy_augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = lazy_augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = lazy_augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = lazy_augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = lazy_augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = lazy_augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = lazy_augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
