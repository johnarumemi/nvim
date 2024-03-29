-- [[ nord theme ]]
-- repo: https://github.com/shaunsingh/nord.nvim

require("lualine").setup({
  options = {
    -- ... your lualine config
    theme = "nord",
    -- ... your lualine config
  },
})

-- Example config in lua
vim.g.nord_contrast = true
vim.g.nord_borders = false
vim.g.nord_disable_background = false
vim.g.nord_italic = false
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold = false

-- Load the colorscheme
require("nord").set()
