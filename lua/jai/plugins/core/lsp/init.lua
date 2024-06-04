return {

  -- Main NeoVim LSP Client config
  -- Order of setup matters, it should be as follows
  -- 1. mason
  -- 2. mason-lspconfig
  -- 3. lspconfig (setup servers)
  {
    "neovim/nvim-lspconfig",
    -- On attach of an LSP client to a server, mason-lspconfig will be run.
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      -- NOTE: this exact format of specifying dependencies is required.
      -- Otherwise, I couldn't get the plugin to work.
      {
        "williamboman/mason-lspconfig.nvim",

        opts = {

          -- NOTE: use lspconfig names here.
          -- for cases where name does not exist in lspconfig, use the "mason" equivalent custom option to install these.
          ensure_installed = {
            "lua_ls",
            "jsonls",
          },

          -- if a server is configured in lsp, this will ensure that mason
          -- installs the necessary LSP server
          automatic_installation = true,
        },
      },

      "hrsh7th/nvim-cmp",

      -- -- TODO: Check the below dependency
      "hrsh7th/cmp-nvim-lsp",

      -- Due to `on_attach` keymaps
      "folke/which-key.nvim",

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim", opts = {} },

      -- automatically create pair of parentheses
      { "windwp/nvim-autopairs", opts = {} },

      { "nvimtools/none-ls.nvim" },
    },

    config = function()
      require("jai.plugins.core.lsp.servers").configure_servers()
    end,
  },
  -- LSP Servers via Mason
  {
    "williamboman/mason.nvim",
    lazy = false,
    -- cmd = "Mason",
    -- keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      -- mason will also automatically install these LSP servers
      -- if they are not present on your computer
      -- NOTE: use mason names here
      ensure_installed = {
        -- note that we actually use stylua through none-ls
        "stylua",
        "flake8",
        -- "ruff", -- ruff can replace flake8 and black
        "black",
        -- "rust-analyzer" -- Hanled by "rust-tools"
      },
    },

    config = function(_, opts)
      require("mason").setup(opts)

      if opts.ensure_installed ~= nil then
        local mr = require("mason-registry")

        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
    end,
  },
  {
    -- repo: https://github.com/mrcjkb/rustaceanvim
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    lazy = false, -- plugin is already lazy
    dependencies = {

      {
        "lvimuser/lsp-inlayhints.nvim",
        opts = {},
      },
    },
    opts = {
      inlay_hints = {
        highlight = "NonText",
      },
      capabilities = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        -- for cpm_nvim_lsp
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      end,
      server = {
        on_attach = function(client, bufnr)
          print("Calling rust on_attach")
          -- apply default on_attach first
          require("jai.plugins.core.lsp.on_attach").on_attach(client, bufnr)

          -- Use below to get inlayhints for neovim 0.9
          -- discussion: https://github.com/mrcjkb/rustaceanvim/discussions/46#discussioncomment-7620822
          require("lsp-inlayhints").on_attach(client, bufnr)

          -- -- Hover actions
          -- vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })

          -- -- Code action groups
          -- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })

          -- Set completeopt to have a better completion experience
          -- :help completeopt
          -- menuone: popup even when there's only one match
          -- noinsert: Do not insert text until a selection is made
          -- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
          vim.api.nvim_set_option_value("completeopt", "menuone,noinsert,noselect", { buf = bufnr })

          -- -- Avoid showing extra messages when using completion
          -- TODO: below seems to be breaking
          -- local current_shortmess = vim.api.nvim_get_option_value("shortmess", { buf = bufnr })
          -- vim.api.nvim_set_option_value("shortmess", current_shortmess + "c", { buf = bufnr })
          -- vim.opt.shortmess = vim.opt.shortmess + "c"

          -- register which-key mappings + add keymaps aswell
          print("Setting keymaps for rust")
          local wk = require("which-key")

          wk.register({
            name = "Rust",
            r = {
              a = {
                function()
                  vim.cmd.RustLsp("codeAction")
                end,
                "Code Action",
              },
              d = {
                function()
                  vim.cmd.RustLsp("debuggables")
                end,
                "Rust debuggables",
              },
              r = {
                function()
                  vim.cmd.RustLsp("runnables")
                end,
                "Rust runnables",
              },
              t = {
                function()
                  vim.cmd.RustLsp("testables")
                end,
                "Rust testables",
              },
            },
          }, {
            prefix = "<leader>",
            mode = "n",
            buffer = bufnr,
            noremap = true,
            silent = true,
          })
          print("Completed rust on_attach")
        end,

        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              -- To prevent check on save taking a lock on the target dir
              -- (blocking cargo build/run)
              extraArgs = { "--target-dir", "target/ra-check", "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      print("Starting rust lsp")
      vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
  },
}
