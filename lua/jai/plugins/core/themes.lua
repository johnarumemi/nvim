return {

  -- [[ Themes ]]
  { "Mofiqul/dracula.nvim", priority = 1000, lazy = false },
  { "marko-cerovac/material.nvim", priority = 1000, lazy = false },
  { "shaunsingh/nord.nvim", priority = 1000, lazy = false },
  { "EdenEast/nightfox.nvim", priority = 1000, lazy = false },
  {
    "folke/tokyonight.nvim",
    branch = "main",
    lazy = false,
    priority = 1000,
    config = function()
      require("jai.plugins.configs.themes.main")
    end,
    dependencies = { "folke/which-key.nvim" },
  },
}
