-- my custom augroups
local function jai_augroup(name)
  return vim.api.nvim_create_augroup("jai_" .. name, { clear = true })
end

--[[
-- Autocommand for git linewraps to occur at
-- set line length
--]]
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = jai_augroup("gitcommit_linewrap"),
  pattern = { "COMMIT_EDITMSG" },
  desc = "Setup gitcommit linewraps",
  callback = function(opts)
    vim.cmd("set conceallevel=3")
    vim.cmd("set wrap")
    vim.cmd("set textwidth=55")
    vim.opt_local.spell = true

    -- update options for current buffer only
    -- num:  Size of an indent
    vim.api.nvim_set_option_value("shiftwidth", 2, { buf = opts.buf })
    --  num:  Number of spaces tabs count for in insert mode
    vim.api.nvim_set_option_value("softtabstop", 2, { buf = opts.buf })
    -- num:  Number of spaces tabs count for
    vim.api.nvim_set_option_value("tabstop", 2, { buf = opts.buf })
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
  group = jai_augroup("norg_concealcursor"),
  desc = "Set norg concealcursor to nc",
  callback = function(opts)
    if vim.bo[opts.buf].filetype == "norg" then
      vim.cmd("set cocu=nc")
    end
  end,
})

-- Create a global variable to store the colorscheme name
vim.g.colorscheme_name = "auto"

-- Create a new command that wraps the colorscheme command
--
--  Now, instead of using the `colorscheme` command,
--  use `colorscheme-auto` to change the
--  colorscheme. This will store the name of the
--  colorscheme in `g:colorscheme_name` before
--  applying it, allowing the autocommand to access
--  the name.
-- vim.api.nvim_command("command! -nargs=1 ColorschemeAuto let g:colorscheme_name = <q-args> | colorscheme <q-args>")

-- vim.api.nvim_exec("command! -nargs=1 ColorschemeAuto let g:colorscheme_name = <q-args> | colorscheme <q-args>", false)

local function fn_colorscheme_auto(opts)
  local notify_title = "Cmd - ColorschemeAuto"

  vim.g.colorscheme_name = opts.args

  vim.notify("Setting terminal colorscheme to " .. opts.args, vim.log.levels.DEBUG, { title = notify_title })

  vim.cmd("colorscheme " .. opts.args)

  vim.notify("Completed setting colorscheme to " .. opts.args, vim.log.levels.DEBUG, { title = notify_title })
end

-- usage = "ColorschemeAuto <colorscheme>",
vim.api.nvim_create_user_command("ColorschemeAuto", fn_colorscheme_auto, {
  nargs = 1,
  complete = "color",
})

local function convert_to_lualine_theme(theme_name)
  if theme_name == "auto" or theme_name == "default" then
    return "auto"
  elseif theme_name:match("tokyonight") then
    return "auto"
  elseif theme_name:match("nightfox") then
    return "nightfox"
  elseif theme_name:match("catppuccin") then
    return "catppuccin"
  elseif theme_name:match("material") then
    return "material"
  elseif theme_name:match("nord") then
    return "nord"
  elseif theme_name:match("dracula") then
    return "dracula-nvim"
  else
    return theme_name
  end
end

-- Usage of this should be paired with the `ColorschemeAuto` command
vim.api.nvim_create_autocmd({ "ColorSchemePre" }, {
  group = jai_augroup("set_lualine_theme"),
  desc = "Set lualine theme on change in colorscheme",
  callback = function()
    local notify_title = "Autocmd - Lualine Theme"

    ---@param msg string
    ---@param level integer
    local notify = function(msg, level)
      vim.notify(msg, level, { title = notify_title })
    end

    local debug = function(msg)
      notify(msg, vim.log.levels.DEBUG)
    end

    local warn = function(msg)
      notify(msg, vim.log.levels.WARN)
    end

    debug("Autocommand to set theme for lualine triggered")

    -- Get current lualine config
    local config = require("lualine").get_config()

    local current_ui_theme = vim.g.colors_name
    local expected_lualine_theme = nil

    if current_ui_theme then
      expected_lualine_theme = convert_to_lualine_theme(vim.g.colors_name)
    else
      expected_lualine_theme = config.options.theme
    end

    local current_lualine_theme = config.options.theme

    if current_ui_theme then
      debug("Current ui theme is " .. current_ui_theme)
    else
      debug("ui theme is not set")
    end

    if expected_lualine_theme ~= current_lualine_theme then
      warn("Lualine theme has diverged from expected theme")
    end

    debug("Actual current lualine theme is " .. current_lualine_theme)
    debug("Expected current lualine theme is " .. expected_lualine_theme)

    -- Use the stored colorscheme name
    local incoming_theme = vim.g.colorscheme_name

    debug("Requesting lualine theme be set to " .. incoming_theme)

    -- Adjustments to convert the colorscheme name
    -- to a lualine theme name
    incoming_theme = convert_to_lualine_theme(incoming_theme)

    debug("Converted lualine theme name is " .. incoming_theme)

    -- if the new lualine theme is the same as the current one, then return
    if incoming_theme == current_lualine_theme and incoming_theme ~= "auto" then
      debug("Lualine theme already set to " .. incoming_theme)
      return
    end

    debug("Setting lualine theme to " .. incoming_theme)

    -- Update the theme in the lualine configuration
    config.options.theme = incoming_theme

    -- Setup lualine with the updated configuration
    require("lualine").setup(config)
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
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   group = lazy_augroup("last_loc"),
--   callback = function(event)
--     local exclude = { "gitcommit" }
--     local buf = event.buf
--     if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
--       return
--     end
--     vim.b[buf].lazyvim_last_loc = true
--     local mark = vim.api.nvim_buf_get_mark(buf, '"')
--     local lcount = vim.api.nvim_buf_line_count(buf)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = lazy_augroup("close_with_q"),
  pattern = {
    "dap-float",
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

vim.api.nvim_create_autocmd("FileType", {
  group = lazy_augroup("close_with_q_force"),
  pattern = {
    "TelescopePrompt",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>q!<cr>", { buffer = event.buf, silent = true })
  end,
})

-- wrap and check for spell in text filetypes
-- vim.api.nvim_create_autocmd("FileType", {
--   group = lazy_augroup("wrap_spell"),
--   pattern = { "gitcommit", "markdown" },
--   callback = function()
--     vim.opt_local.wrap = true
--     vim.opt_local.spell = true
--   end,
-- })

-- Fix conceallevel for json files
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   group = lazy_augroup("json_conceal"),
--   pattern = { "json", "jsonc", "json5" },
--   callback = function()
--     vim.opt_local.conceallevel = 0
--   end,
-- })

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
