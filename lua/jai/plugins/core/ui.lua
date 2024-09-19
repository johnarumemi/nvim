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
