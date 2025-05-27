return {
  {
    "nvim-tree/nvim-tree.lua",
    -- File explorer is redundant in VS Code
    enabled = function()
      return not vim.g.vscode
    end,
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
    -- Telescope is redundant with VS Code's search
    enabled = function()
      return not vim.g.vscode
    end,
    dependencies = { "nvim-lua/plenary.nvim", "folke/which-key.nvim" },
    lazy = false,
    opts = {
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    },
    config = function()
      local wk = require("which-key")

      wk.add({
        -- Find [operation]
        { "<leader>fb", ":Telescope buffers<CR>", desc = "Buffers" },
        { "<leader>ff", ":Telescope find_files<CR>", desc = "Find File" },
        { "<leader>fg", ":Telescope live_grep<CR>", desc = "Grep In Files" },
        { "<leader>fh", ":Telescope help_tags<CR>", desc = "Help Tags" },

        -- Open [operation]
        { "<leader>ot", ":Telescope<CR>", desc = "Open Telescope" },
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
        { "<leader>f", group = "Find" },
        { "<leader>o", group = "Open" },
        { "<leader>t", group = "Toggle" },
      })
    end,
  },
  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  --
  -- repo: https://github.com/RRethy/vim-illuminate
  {
    "RRethy/vim-illuminate",
    -- Keep illuminate in VS Code for highlighting words under cursor
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
  {
    -- repo: https://github.com/folke/todo-comments.nvim
    -- see here for icons: https://www.nerdfonts.com/cheat-sheet
    "folke/todo-comments.nvim",
    -- VS Code has its own TODO highlighting
    enabled = function()
      return not vim.g.vscode
    end,
    cmd = { "TodoTrouble", "TodoTelescope" },

    -- event = "LazyFile",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = { "folke/which-key.nvim" },
    opts = {
      -- NOTE: below keywords will be merged with exisiting keywords
      keywords = {

        NEW = { icon = " ", color = "pale_green", alt = { "New" } },
        REVIEW = { icon = " ", color = "hint", alt = { "Review" } },
        TODO = { icon = " ", color = "info" },
        IMPORTANT = { icon = " ", color = "pale_red", alt = { "Important", "Key", "KEY" } },
        LEARN = { icon = " ", color = "hint", alt = { "Learn", "LEARN" } },
        DEPRECATED = { icon = " ", color = "orange", alt = { "Deprecated", "deprecated" } },
        OBSOLETE = { icon = " ", color = "orange", alt = { "Obsolete", "obsolete" } },
      },
      colors = {
        pale_green = { "#98fb98 " },
        pale_red = { "#ffcccb" },
        orange = { "#ff8000" },
      },
    },

    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find Todo All" },
      { "<leader>fa", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
}
