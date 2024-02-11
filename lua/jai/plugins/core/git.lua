-- plugins related to git / versioning

return {
  { "tpope/vim-fugitive" }, -- git integration
  { "junegunn/gv.vim" }, -- commit history

  -- Gitsigns depends on which-key due to various keymaps
  -- that I have setup.
  {

    "lewis6991/gitsigns.nvim",
    tag = "v0.6",
    dependencies = { "folke/which-key.nvim" },
    config = function()
      local gitsigns_config = require("jai.plugins.configs.gitsigns_config")
      require("gitsigns").setup(gitsigns_config.config)
    end,
  },

  -- open current line in web
  -- <leader>g to view options
  { "ruanyl/vim-gh-line" },
}
