return {

  -- [[ Themes ]]
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    lazy = false,
  },
  {
    "marko-cerovac/material.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      local config = require("jai.plugins.core.themes.material_ui")
      vim.g.material_style = config.material_style
      require("material").setup(config.opts)
    end,
  },
  {
    "shaunsingh/moonlight.nvim",
    priority = 1000,
    lazy = false,
  },
  {
    "shaunsingh/nord.nvim",
    priority = 1000,
    lazy = false,
    init = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = false
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = false
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    lazy = false,
    opts = function()
      return require("jai.plugins.core.themes.nightfox")
    end,
  },
  {
    "folke/tokyonight.nvim",
    branch = "main",
    lazy = false,
    priority = 1000,
    opts = { style = "moon" },
    -- opts = function()
    --   return require("jai.plugins.core.themes.tokyonight")
    -- end,
    -- dependencies = { "folke/which-key.nvim" },
  },
  {
    -- repo: https://github.com/0xstepit/flow.nvim?tab=readme-ov-file
    "0xstepit/flow.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      dark_theme = true,
      transparent = false,
      high_contrast = false,
      fluo_color = "pink",
      mode = "desaturate",
      aggressive_spell = false,
    },
  },
  {
    -- repo: https://github.com/catppuccin/nvim
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = function()
      return require("jai.plugins.core.themes.catppuccin")
    end,
  },
}
