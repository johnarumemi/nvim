return {

  {
    -- [[ Main dashboard ]]
    "glepnir/dashboard-nvim",
    -- Dashboard is redundant in VS Code
    enabled = function()
      return not vim.g.vscode
    end,
    event = "VimEnter",
    config = function()
      local config = require("jai.plugins.configs.dashboard_config")
      require("dashboard").setup(config.opts)
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>od", ":Dashboard<CR>", desc = "Open Dashboard" },
    },
  },

  -- [[ Icons ]]
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    -- Icons aren't needed in VS Code
    enabled = function()
      return not vim.g.vscode
    end,
  },

  -- [[ UI Components
  {
    "nvim-lualine/lualine.nvim",
    -- Status line is redundant in VS Code
    enabled = function()
      return not vim.g.vscode
    end,
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      { "arkav/lualine-lsp-progress", opts = {} },
    },
    opts = {
      options = {
        disabled_filetypes = {
          -- "dapui_watches",
          -- "dapui_breakpoints",
          -- "dapui_scopes",
          -- "dapui_console",
          -- "dapui_stacks",
          -- "dap-repl",
          "NvimTree",
        },
        ignore_focus = {
          "dapui_watches",
          "dapui_breakpoints",
          "dapui_scopes",
          "dapui_console",
          "dapui_stacks",
          "dap-repl",
          "NvimTree",
        },
        sections = {
          lualine_c = { "lsp_progress" },

          -- copilot status within lualine
          lualine_x = { { "copilot", show_colors = true }, "encoding", "fileformat", "filetype" },
        },
      },
    },
  },
  -- [[ Tabline ]]
  {
    -- Note: Config taken from LazyVim
    -- LazyVim config: http://www.lazyvim.org/plugins/ui#bufferlinenvim
    -- repo: https://github.com/akinsho/bufferline.nvim
    "akinsho/bufferline.nvim",
    -- Tabline is redundant in VS Code
    enabled = function()
      return not vim.g.vscode
    end,
    version = "^v4.7",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "<leader>b", group = "Bufferline" },
      -- TODO: Shift to separate config file and use which-key to create a `buffer` group
      { "<leader>bc", "<Cmd>BufferLinePickClose<CR>", desc = "Pick Buffer to Close" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      -- Hold Shift and use h and l.
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      -- Hold Option and use , and .
      { "<A-,>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<A-.>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      -- Use below to shift buffer order manually
      { "[b", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]b", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
      -- stylua: ignore
      close_command = function(n)
        local M = require("jai.util.ui")
        M.bufremove(n)
      end,
      -- stylua: ignore
      right_mouse_command = function(n)
        local M = require("jai.util.ui")
        M.bufremove(n)
      end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
  {
    --   -- bufferline with `rose-pine` theme set
    --   -- repo: https://github.com/rose-pine/neovim/wiki/Plugin-configurations#bufferlinenvim
    "akinsho/bufferline.nvim",
    -- Tabline theme is redundant in VS Code
    enabled = function()
      return not vim.g.vscode
    end,
    event = "ColorScheme",
    config = function()
      local highlights = require("rose-pine.plugins.bufferline")
      require("bufferline").setup({ highlights = highlights })
    end,
  },
  {
    -- Delete current buffer
    -- repo: https://github.com/famiu/bufdelete.nvim
    "famiu/bufdelete.nvim",
    keys = {
      {
        "<leader>bd",
        function()
          require("bufdelete").bufdelete(0, true)
        end,
        desc = "Delete Current Buffer",
      },
      {
        "<A-c>",
        function()
          require("bufdelete").bufdelete(0, true)
        end,
        desc = "Delete Current Buffer",
      },
    },
  },

  --- repo: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-trailspace.md
  {
    "echasnovski/mini.trailspace",
    branch = "stable",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      local wk = require("which-key")

      local mt = require("mini.trailspace")

      -- IMPORTANT: Below need autocommands that run on file save
      -- TODO: Below need autocommands that run on file save
      wk.add({
        { "<leader>m", group = "Mini" },
        {
          "<leader>mt",
          function()
            mt.trim()
          end,
          desc = "Trim trailing whitespace",
        },

        {
          "<leader>ml",
          function()
            mt.trim_last_lines()
          end,
          desc = "Trim last blank lines",
        },
      })
    end,
  },

  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "echasnovski/mini.indentscope",
    -- Keep indent scope enabled in VS Code as it's still useful
    version = false, -- wait till new 0.7.0 release to put it back on semver
    branch = "stable",
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
    -- Notifications are redundant in VS Code
    enabled = function()
      return not vim.g.vscode
    end,
    event = "VeryLazy",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
      {
        "<leader>on",
        ":Notifications<CR>",
        desc = "Open all notifications",
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
  {
    -- Replacement command-line for Neovim
    -- repo: https://github.com/folke/noice.nvim
    "folke/noice.nvim",
    -- Already disabled, but let's make it explicit
    enabled = function()
      return false and not vim.g.vscode
    end,
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-notify",
      "MunifTanjim/nui.nvim",
    },
    opts = function()
      local config = require("jai.plugins.configs.noice")

      return config.opts
    end,
  },
  {
    -- repo: https://github.com/folke/zen-mode.nvim
    "folke/zen-mode.nvim",
    -- Zen mode can be useful in VS Code too, keep it
    lazy = false,
    keys = {
      { "<leader>tz", ":ZenMode<CR>", desc = "Toggle Zen Mode" },
    },
    opts = {
      window = {
        backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        -- height and width can be:
        -- * an absolute number of cells when > 1
        -- * a percentage of the width / height of the editor when <= 1
        -- * a function that returns the width or the height
        width = 100, -- width of the Zen window
        height = 1, -- height of the Zen window
        -- by default, no options are changed for the Zen window
        -- uncomment any of the options below, or add other vim.wo options you want to apply
        options = {
          -- signcolumn = "no", -- disable signcolumn
          number = false, -- disable number column
          -- relativenumber = false, -- disable relative numbers
          -- cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          -- foldcolumn = "0", -- disable fold column
          -- list = false, -- disable whitespace characters
        },
      },
      plugins = {
        -- disable some global vim options (vim.o...)
        -- comment the lines to not apply the options
        options = {
          enabled = true,
          ruler = false, -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
          -- you may turn on/off statusline in zen mode by setting 'laststatus'
          -- statusline will be shown only if 'laststatus' == 3
          laststatus = 0, -- turn off the statusline in zen mode
        },
        twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = true }, -- disables git signs
        tmux = { enabled = true }, -- disables the tmux statusline
        todo = { enabled = false }, -- if set to "true", todo-comments.nvim highlights will be disabled
        -- this will change the font size on kitty when in zen mode
        -- to make this work, you need to set the following kitty options:
        -- - allow_remote_control socket-only
        -- - listen_on unix:/tmp/kitty
        kitty = {
          enabled = false,
          font = "+4", -- font size increment
        },
        -- this will change the font size on alacritty when in zen mode
        -- requires  Alacritty Version 0.10.0 or higher
        -- uses `alacritty msg` subcommand to change font size
        alacritty = {
          enabled = false,
          font = "14", -- font size
        },
        -- this will change the font size on wezterm when in zen mode
        -- See alse also the Plugins/Wezterm section in this projects README
        wezterm = {
          enabled = false,
          -- can be either an absolute font size or the number of incremental steps
          font = "+4", -- (10% increase per step)
        },
        -- this will change the scale factor in Neovide when in zen mode
        -- See alse also the Plugins/Wezterm section in this projects README
        neovide = {
          enabled = false,
          -- Will multiply the current scale factor by this number
          scale = 1.2,
          -- disable the Neovide animations while in Zen mode
          disable_animations = {
            neovide_animation_length = 0,
            neovide_cursor_animate_command_line = false,
            neovide_scroll_animation_length = 0,
            neovide_position_animation_length = 0,
            neovide_cursor_animation_length = 0,
            neovide_cursor_vfx_mode = "",
          },
        },
      },
      -- callback where you can add custom code when the Zen window opens
      on_open = function(win)
        local buf = vim.api.nvim_get_current_buf()

        if vim.bo[buf].filetype == "norg" then
          vim.g.original_spell = vim.api.nvim_get_option_value("spell", { scope = "local", win = 0 })

          vim.api.nvim_set_option_value("spell", false, { scope = "local", win = 0 })

          require("illuminate").invisible_buf()
        end
      end,
      -- callback where you can add custom code when the Zen window closes
      on_close = function()
        local buf = vim.api.nvim_get_current_buf()

        if vim.bo[buf].filetype == "norg" then
          if vim.g.original_spell == nil then
            return
          end

          local spell_value = nil

          if type(vim.g.original_spell) == "string" then
            spell_value = vim.g.original_spell == "spell"
          else
            spell_value = vim.g.original_spell
          end

          vim.api.nvim_set_option_value("spell", spell_value, { scope = "local", win = 0 })

          require("illuminate").visible_buf()
        end
      end,
    },
  },
  {
    -- repo: https://github.com/folke/twilight.nvim
    "folke/twilight.nvim",
    -- Twilight can be useful in VS Code too, keep it
    opts = {
      dimming = {
        alpha = 0.25, -- amount of dimming
        -- we try to get the foreground from the highlight groups or fallback color
        color = { "Normal", "#ffffff" },
        term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
        inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
      },
      context = 10, -- amount of lines we will try to show around the current line
      treesitter = true, -- use treesitter when available for the filetype
      -- treesitter is used to automatically expand the visible text,
      -- but you can further control the types of nodes that should always be fully expanded
      -- NOTE: these are nodes found via `:InspectTree`
      expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
        "function",
        "method",
        "table",
        "if_statement",
        "heading2",
      },
      exclude = {}, -- exclude these filetypes
    },
  },
}
