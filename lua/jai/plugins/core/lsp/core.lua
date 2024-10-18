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
          -- for cases where name does not exist in lspconfig,
          -- use the "mason" equivalent custom option to install these.
          ensure_installed = {},

          -- if a server is configured in lsp, this will ensure that mason
          -- installs the necessary LSP server
          automatic_installation = true,
        },
      },

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
    opts = {
      -- repo: https://github.com/klauspost/asmfmt#formatting
      -- blog: https://blog.klauspost.com/asmfmt-assembler-formatter/
      -- "ruff", -- ruff can replace flake8 and black
      ensure_installed = {
        "black",

        "asmfmt",
        "yamlfmt",
        "yamllint",

        -- Ensure C/C++ debugger is installed
        "codelldb",
        "cmakelang",
        "cmakelint",
      },
    },
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
