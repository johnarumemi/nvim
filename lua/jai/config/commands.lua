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
