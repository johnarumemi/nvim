return {
  {
    "nvim-tree/nvim-tree.lua",
    -- this should always be loaded and not lazy loaded
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/which-key.nvim" },
    opts = {
      view = {
        width = 30,
      },
      update_focused_file = {
        enable = true,
        -- 	update_root = true,
      },
      filters = {
        dotfiles = true,
        custom = { "node_modules", "__pycache__" },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      local wk = require("which-key")

      wk.register({
        --
        -- <leader>n
        --
        n = { [[:NvimTreeToggle<CR>]], "Toggle Tree" },
      }, { prefix = "<leader>" })
    end,
  },
  {

    "nvim-telescope/telescope.nvim", -- fuzzy finder
    dependencies = { "nvim-lua/plenary.nvim", "folke/which-key.nvim" },
    lazy = false,
    config = function()
      local wk = require("which-key")

      wk.register({
        t = {
          name = "Toggle",
          s = { [[:Telescope<CR>]], "Open Telescope" }, -- create finding
        },
        f = {
          name = "Files",
          f = { [[:Telescope find_files<CR>]], "Find File" }, -- create "folke/which-key.nvim"finding
          g = { [[:Telescope live_grep<CR>]], "Grep In Files" }, -- create finding
          b = { [[:Telescope buffers<CR>]], "Buffers" }, -- create finding
          h = { [[:Telescope help_tags<CR>]], "Help Tags" }, -- create finding
        },
      }, { prefix = "<leader>" })
    end,
  },

  {
    "folke/which-key.nvim",
    version = "main",
    lazy = false,

    opts = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          -- TODO: what does setting below to true actually do then?
          enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      -- add operators that will trigger motion and text object completion
      -- to enable all native operators, set the preset / operators plugin above
      operators = { gc = "Comments" },
      key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
      },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
      },
      window = {
        border = "none", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
      },
      -- TODO: below might be useful to set to true
      ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
      show_help = true, -- show help message on the command line when the popup is visible
      show_keys = true, -- show the currently pressed key and its label as a message in the command line
      triggers = "auto", -- automatically setup triggers
      -- triggers = {"<leader>"} -- or specify a list manually
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
      },
      -- disable the WhichKey popup for certain buf types and file types.
      -- Disabled by deafult for Telescope
      disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt" },
      },
    },
    config = function(_, opts)
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup(opts)

      -- other general keymappings
      -- require("jai.plugins.general_keymaps")
    end,
  },
}
