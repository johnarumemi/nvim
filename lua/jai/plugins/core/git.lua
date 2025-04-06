-- plugins related to git / versioning

return {
  {
    -- git integration
    "tpope/vim-fugitive",
    -- Disable fugitive in VS Code as it has its own Git integration
    enabled = function()
      return not vim.g.vscode
    end,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  },
  {
    -- commit history
    "junegunn/gv.vim",
    -- Disable gv in VS Code as it has its own Git history view
    enabled = function()
      return not vim.g.vscode
    end,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  },
  {
    -- Gitsigns depends on which-key due to various keymaps
    -- that I have setup.

    "lewis6991/gitsigns.nvim",
    -- Disable gitsigns in VS Code as it has its own Git indicators
    enabled = function()
      return not vim.g.vscode
    end,
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
  -- repo: https://github.com/ruanyl/vim-gh-line
  {
    "ruanyl/vim-gh-line",
    -- Disable vim-gh-line in VS Code as it has GitHub integration
    enabled = function()
      return not vim.g.vscode
    end,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = { "folke/which-key.nvim" },
    config = function()
      local wk = require("which-key")

      wk.add({
        { "<leader>g", group = "GitHub", mode = { "n", "v" } },
      })
    end,
  },

  {
    -- repo: https://github.com/sindrets/diffview.nvim
    "sindrets/diffview.nvim",
    -- Disable diffview in VS Code as it has its own diff view
    enabled = function()
      return not vim.g.vscode
    end,
    cmd = { "DiffviewOpen" },
    opts = function()
      local config = require("jai.plugins.configs.diffview_config")
      require("diffview").setup(config.opts)
    end,
  },
}
