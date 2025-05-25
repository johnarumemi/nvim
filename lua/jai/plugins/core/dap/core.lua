return {
  -- [[ nvim-dap ]]
  -- repo: https://github.com/mfussenegger/nvim-dap
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

    dependencies = {
      -- fancy ui for the debugger
      "rcarriga/nvim-dap-ui",
      {
        -- [[ nvim-dap-virtual-text ]]
        -- repo: https://github.com/theHamsta/nvim-dap-virtual-text
        -- virtual text for the debugger
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      {

        -- [[ Dap adapter for the Neovim lua language ]]
        "jbyuki/one-small-step-for-vimkind",
      },
    },

  -- stylua: ignore
  keys = {
    { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>da", function() require("dap").continue({ before = JUtil.get_args }) end, desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    -- [[ below are used for moving up and down the stack frame ]]
    { "<leader>dj", function() require("dap").down() end, desc = "Frame Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Frame Up" },
    --
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },

    config = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      if JUtil.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(JUtil.opts("mason-nvim-dap.nvim"))
      else
        warn("No mason-nvim-dap.nvim package found, skipping it's setup")
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- for name, sign in pairs(LazyVim.config.icons.dap) do
      --   sign = type(sign) == "table" and sign or { sign }
      --   vim.fn.sign_define(
      --     "Dap" .. name,
      --     { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      --   )
      -- end

      -- setup dap config by VsCode launch.json file
      if vim.g.vscode then
        local vscode = require("dap.ext.vscode")
        local json = require("plenary.json")
        vscode.json_decode = function(str)
          return vim.json.decode(json.json_strip_comments(str))
        end

        -- Extends dap.configurations with entries read from .vscode/launch.json
        if vim.fn.filereadable(".vscode/launch.json") then
          vscode.load_launchjs()
        end
      end
    end,
  },

  -- [[ nvim-dap-ui ]]
  -- A fancy UI for the debugger
  -- repo: https://github.com/rcarriga/nvim-dap-ui
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      -- A library for asynchronous IO in Neovim, inspired by the asyncio library in Python.
      -- repo: https://github.com/nvim-neotest/nvim-nio
      "nvim-neotest/nvim-nio",
    },
  -- stylua: ignore
  keys = {
    { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
  },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
      -- [[ mason.nvim integration ]]
      -- repo: https://github.com/jay-babu/mason-nvim-dap.nvim
  not _G.is_nix_env
      and {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "nvim-dap", "williamboman/mason.nvim" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_installation = true,

          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},

          -- You'll need to check that you have the required things installed
          -- online, please don't ask me how to install them :)
          ensure_installed = {
            -- see mappings for dap name -> Mason name
            -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
            -- Update this to ensure that you have the debuggers for the langs you want
            -- codelldb  and cpptools is for Rust and C/C++ debugging.
            "codelldb",
            "cppdbg", -- nvim_dap adapter name for cpptools in Mason pacakge name
          },
        },
        -- mason-nvim-dap is loaded when nvim-dap loads
        -- use empty config below to ensure lazy doesn't call <module>.setup()
        config = function() end,
      }
    or nil,
}
