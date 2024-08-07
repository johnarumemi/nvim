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
        "flake8",
        -- "ruff", -- ruff can replace flake8 and black
        "black",
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
        "MysticalDevil/inlay-hints.nvim",
        event = "LspAttach",
        dependencies = { "neovim/nvim-lspconfig" },
      },
    },
    opts = {
      capabilities = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        -- for cpm_nvim_lsp
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      end,
      server = {
        on_attach = function(client, bufnr)
          -- apply default on_attach first
          require("jai.plugins.core.lsp.on_attach").on_attach(client, bufnr)
          require("inlay-hints").on_attach(client, bufnr)

          -- -- Hover actions
          -- vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })

          -- -- Code action groups
          -- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })

          -- Set completeopt to have a better completion experience
          -- :help completeopt
          -- menuone: popup even when there's only one match
          -- noinsert: Do not insert text until a selection is made
          -- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
          if vim.fn.has("nvim-0.10") == 0 then
            -- only use below in neo-vim < 0.10
            -- It does not appear to work in 0.10 or we get below error:
            -- Error: 'buf' cannot be passed for global option 'completeopt'"
            vim.api.nvim_set_option_value("completeopt", "menuone,noinsert,noselect", { buf = bufnr })
          end

          -- -- Avoid showing extra messages when using completion
          -- TODO: below seems to be breaking
          -- local current_shortmess = vim.api.nvim_get_option_value("shortmess", { buf = bufnr })
          -- vim.api.nvim_set_option_value("shortmess", current_shortmess + "c", { buf = bufnr })
          -- vim.opt.shortmess = vim.opt.shortmess + "c"

          -- register which-key mappings + add keymaps aswell
          local wk = require("which-key")

          wk.add({
            { "<leader>r ", buffer = bufnr, group = "Rust", remap = false },
            {
              "<leader>ra",
              function()
                vim.cmd.RustLsp("codeAction")
              end,
              buffer = bufnr,
              desc = "Code Action",
              remap = false,
            },
            {
              "<leader>rd",
              function()
                vim.cmd.RustLsp("debuggables")
              end,
              buffer = bufnr,
              desc = "Rust debuggables",
              remap = false,
            },
            {
              "<leader>rr",
              function()
                vim.cmd.RustLsp("runnables")
              end,
              buffer = bufnr,
              desc = "Rust runnables",
              remap = false,
            },
            {
              "<leader>rt",
              function()
                vim.cmd.RustLsp("testables")
              end,
              buffer = bufnr,
              desc = "Rust testables",
              remap = false,
            },
          })
        end,

        default_settings = {
          -- rust-analyzer language server configuration
          -- For detailed descriptions of the language server configs, see the
          -- rust-analyzer documentation below:
          --
          -- https://rust-analyzer.github.io/manual.html#configuration
          --
          ["rust-analyzer"] = {
            cargo = {
              features = { "all" },
            }, -- End of cargo settingsj
            -- Add clippy lints for Rust.
            checkOnSave = true,
            check = {
              features = { "all" },
              command = "clippy", -- use `cargo clippy` rather than `cargo check`
              -- To prevent check on save taking a lock on the target dir
              -- (blocking cargo build/run)
              extraArgs = { "--target-dir", "target/ra-check", "--no-deps" },
            }, -- End of check settings
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            }, -- End of procMacro settings
            inlayHints = {
              bindingModeHints = {
                enable = false,
              },
              chainingHints = {
                enable = true,
              },
              closingBraceHints = {
                enable = true,
                minLines = 25,
              },
              closureReturnTypeHints = {
                enable = "never",
              },
              lifetimeElisionHints = {
                enable = "never",
                useParameterNames = false,
              },
              maxLength = 25,
              parameterHints = {
                enable = true,
              },
              reborrowHints = {
                enable = "never",
              },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            }, -- End of inlayHints settings
          }, -- End of rust-analyzer settings
        }, -- End of default_settings
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
  },
}
