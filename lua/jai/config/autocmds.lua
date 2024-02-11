--[[
-- Autocommand for git linewraps to occur at
-- set line length
--]]
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "COMMIT_EDITMSG" },
  desc = "Setup gitcommit linewraps",
  callback = function()
    vim.cmd("set conceallevel=3")
    vim.cmd("set wrap")
    vim.cmd("set textwidth=55")
    -- vim.cmd("colorscheme terafox")

    -- update options for current buffer only
    -- num:  Size of an indent
    vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
    --  num:  Number of spaces tabs count for in insert mode
    vim.api.nvim_buf_set_option(0, "softtabstop", 2)
    -- num:  Number of spaces tabs count for
    vim.api.nvim_buf_set_option(0, "tabstop", 2)
  end,
})
