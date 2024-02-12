return {
  -- [[ Main dashboard ]]

  {
    "glepnir/dashboard-nvim",
    enabled = true,
    event = "VimEnter",
    config = function()
      local config = require("jai.plugins.configs.dashboard_config")
      require("dashboard").setup(config.opts)
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- [[ Icons ]]
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- [[ UI Components
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "arkav/lualine-lsp-progress",
    },
    opts = {
      sections = {
        lualine_c = {
          "lsp_progress",
        },
      },
    },
  },
  {
    "arkav/lualine-lsp-progress",
  },

  -- [[ Themes ]]
  { "Mofiqul/dracula.nvim" },
  { "marko-cerovac/material.nvim" },
  { "shaunsingh/nord.nvim" },
  { "EdenEast/nightfox.nvim" },
  {
    "folke/tokyonight.nvim",
    version = "main",
    lazy = false,
    priority = 1000,
    config = function()
      require("jai.plugins.configs.themes.main")
    end,
  },

  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    -- https://github.com/LazyVim/LazyVim/discussions/1583#discussioncomment-7187450
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    -- event = "LazyFile",
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
