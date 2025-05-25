return {

  -- Main NeoVim LSP Client config
  -- Order of setup matters, it should be as follows
  -- 1. mason
  -- 2. mason-lspconfig
  -- 3. lspconfig (setup servers)
  {
    "neovim/nvim-lspconfig",
    -- Disable LSP when running in VS Code as it has its own LSP implementation
    enabled = function()
      return not vim.g.vscode
    end,
    -- On attach of an LSP client to a server, mason-lspconfig will be run.
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      not _G.is_nix_env and {

        "williamboman/mason.nvim",
        enable = not _G.is_nix_env,
      } or nil,
          -- NOTE: this exact format of specifying dependencies is required.
          -- Otherwise, I couldn't get the plugin to work.
      not _G.is_nix_env
          and {
            "williamboman/mason-lspconfig.nvim",
            enable = not _G.is_nix_env,
            opts = {

              -- NOTE: use lspconfig names here.
              -- for cases where name does not exist in lspconfig,
              -- use the "mason" equivalent custom option to install these.
              ensure_installed = {},

              -- if a server is configured in lsp, this will ensure that mason
              -- installs the necessary LSP server
              automatic_installation = true,
            },
          }
        or nil,

      { -- optional completion source for require statements and module annotations
        "hrsh7th/nvim-cmp",
        dependencies = {
          "Saecki/crates.nvim",
        },
        opts = function(_, opts)
          vim.debug("Running nvim-cmp lsp setup", { title = "Completion" })
          opts.sources = opts.sources or {}
          table.insert(opts.sources, {
            name = "lazydev",
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
          })

          table.insert(opts.sources, {
            name = "emoji",
          })
        end,
      },

      -- -- TODO: Check the below dependency
      "hrsh7th/cmp-nvim-lsp",

      -- Due to `on_attach` keymaps
      "folke/which-key.nvim",

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },

      -- automatically create pair of parentheses
      { "windwp/nvim-autopairs" },

      { "nvimtools/none-ls.nvim" },
    },

    config = function()
      require("jai.plugins.core.lsp.servers").configure_servers()
    end,
  },

  {
    -- repo: https://github.com/MysticalDevil/inlay-hints.nvim
    "MysticalDevil/inlay-hints.nvim",
    -- Disable inlay hints in VS Code
    enabled = function()
      return not vim.g.vscode
    end,
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup()
    end,
  },

  {
    -- repo: https://github.com/windwp/nvim-autopairs
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  -- LSP Servers via Mason
  {
    "williamboman/mason.nvim",
    -- Disable Mason when running in VS Code
    enabled = function()
      return not vim.g.vscode and not _G.is_nix_env
    end,
    lazy = false,

    opts = function()
      -- Mason tools to ensure are installed on
      -- both Mac and Linux
      local base = {
        -- Mac and Linux
        "yamlfmt",
        "yamllint",
        "sql-formatter",
        -- Ensure C/C++ debugger is installed
        "codelldb",
        "cmakelang",
        "cmakelint",
        "nil",
      }

      -- Mac Specific
      local mac_only = {
        -- Mac Specific
        -- repo: https://github.com/klauspost/asmfmt#formatting
        -- blog: https://blog.klauspost.com/asmfmt-assembler-formatter/
        "asmfmt",
      }

      if JUtil.os.is_mac() then
        vim.list_extend(base, mac_only)
      end

      return {
        ---@since 1.0.0
        -- Where Mason should put its bin location in your PATH. Can be one of:
        -- - "prepend" (default, Mason's bin location is put first in PATH)
        -- - "append" (Mason's bin location is put at the end of PATH)
        -- - "skip" (doesn't modify PATH)
        ---@type '"prepend"' | '"append"' | '"skip"'
        PATH = "append",
        ensure_installed = base,
      }
    end,
    -- refreshing registry: https://github.com/williamboman/mason.nvim/blob/main/doc/mason.txt#L542
    config = function(_, opts)
      require("mason").setup(opts)

      local refreshed = false
      if opts.ensure_installed ~= nil then
        local mr = require("mason-registry")

        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            -- refresh mason registry first if package is not installed
            if not refreshed then
              mr.refresh(function()
                p:install()
                refreshed = true
              end)
            else
              -- else just go straight to attempting to install the package
              p:install()
            end
          end
        end
      end
    end,
  },
}
