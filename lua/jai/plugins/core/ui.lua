return {

  {
    -- [[ Main dashboard ]]
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
      { "arkav/lualine-lsp-progress", opts = {} },
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

    -- [[ barbar ]]
    -- repo: https://github.com/romgrk/barbar.ngroup_namevim
    -- when using iterm2, change following:
    -- 1. goto profiles -> select a profile to apply changes to
    -- 2. go to 'keys' tab
    -- 3. set "Left Option Key" and/or "Right Option Key" to "Esc+"
    --
    -- The above will ensure the correct escape sequence is sent
    -- by the "Option" key on a Mac so that is acts like "Alt"
    -- on other keyboards. This will enable the <A-...> keymaps
    -- below to work correctly.

    "romgrk/barbar.nvim",
    version = "v1.6.*",
    lazy = false,
    dependencies = {
      "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
      "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    },
    config = function()
      require("barbar").setup()

      -- loading in keymaps
      require("jai.plugins.configs.barbar_config")
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

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    init = function()
      vim.opt.termguicolors = true
      vim.notify = require("notify")
    end,
  },
}
