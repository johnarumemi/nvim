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

      wk.add({
        { "<leader>n", ":NvimTreeToggle<CR>", desc = "Toggle Tree" },
      })
    end,
  },
  {

    "nvim-telescope/telescope.nvim", -- fuzzy finder
    dependencies = { "nvim-lua/plenary.nvim", "folke/which-key.nvim" },
    lazy = false,
    config = function()
      local wk = require("which-key")

      wk.add({
        { "<leader>f", group = "Files" },
        { "<leader>fb", ":Telescope buffers<CR>", desc = "Buffers" },
        { "<leader>ff", ":Telescope find_files<CR>", desc = "Find File" },
        { "<leader>fg", ":Telescope live_grep<CR>", desc = "Grep In Files" },
        { "<leader>fh", ":Telescope help_tags<CR>", desc = "Help Tags" },
        { "<leader>ts", ":Telescope<CR>", desc = "Open Telescope" },
      })
    end,
  },

  {
    "folke/which-key.nvim",
    branch = "main",
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
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
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
      local wk = require("which-key")

      wk.setup(opts)

      -- Global groups
      wk.add({
        { "<leader>t", group = "Toggle" },
      })
    end,
  },
  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  --
  -- config taken from LazyVim (see below)
  -- config: http://www.lazyvim.org/plugins/editor#vim-illuminate
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    -- event = "LazyFile",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },
}
