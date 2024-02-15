-- plugins related to git / versioning

return {
  {
    -- git integration
    "tpope/vim-fugitive",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  },
  {
    -- commit history
    "junegunn/gv.vim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  },
  {
    -- Gitsigns depends on which-key due to various keymaps
    -- that I have setup.

    "lewis6991/gitsigns.nvim",
    version = false,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    -- event = "LazyFile",
    dependencies = { "folke/which-key.nvim" },
    config = function()
      local gitsigns_config = require("jai.plugins.configs.gitsigns_config")
      require("gitsigns").setup(gitsigns_config.config)
    end,
  },

  -- open current line in web
  -- <leader>g to view options
  {
    "ruanyl/vim-gh-line",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  },
}
