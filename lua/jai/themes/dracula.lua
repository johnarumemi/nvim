-- [[ Dracula Theme Configuration ]]

vim.cmd('colorscheme dracula')       -- cmd:  Set colorscheme to use dracula plugin

require('lualine').setup {
  options = {
    theme = 'dracula-nvim'
  }
}
