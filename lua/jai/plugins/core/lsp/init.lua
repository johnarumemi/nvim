vim.g.answer = 1
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

      -- TODO: Check the below dependency
      "hrsh7th/cmp-nvim-lsp",

      -- Due to `on_attach` keymaps
      "folke/which-key.nvim",

      -- Manages rust lsp (repo is archived)
      "simrat39/rust-tools.nvim",

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

    "simrat39/rust-tools.nvim",
    config = function(_, _)
      local config = require("jai.plugins.core.lsp.rust")
      require("rust-tools").setup(config.opts)
    end,
  },
}
