return {

        -- Main NeoVim LSP Client config
        {
			"neovim/nvim-lspconfig",

            dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
            -- TODO: Check the below dependency
      "hrsh7th/cmp-nvim-lsp",
      -- Due to `on_attach` keymaps
      "folke/which-key.nvim",

      -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        {"j-hui/fidget.nvim" , opts = {}},
		"simrat39/rust-tools.nvim",
            },

            config = function()
                require("jai.plugins.core.lsp.servers").configure_servers()
            end
        },
        -- LSP Servers via Mason
        {
			"williamboman/mason.nvim",

    opts = {
	-- mason will also automatically install these LSP servers
	-- if they are not present on your computer
        -- NOTE: use mason names here
      ensure_installed = {
          -- note that we actuall use stylua through none-ls
        -- "stylua",
        -- "jsonls",
        "flake8",
        -- "rust-analyzer"
      },
    },

            config = function(plugin, opts)

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
            end

        },
        {
            "williamboman/mason-lspconfig",
            event = { "VeryLazy" },
            dependencies = {
              "williamboman/mason.nvim"
            },
            opts = {

                -- NOTE: use lspconfig names here.
                -- for cases where name does not exist in lspconfig, use the "mason" equivalent custom option to install these.
      ensure_installed = {
        "lua_ls",
        "jsonls",
        -- "flake8",
        -- "rust-analyzer"
      },

	-- if a server is configured in lsp, this will ensure that mason
	-- installs the necessary LSP server
	automatic_installation = true,
            },

        },
        {

		"simrat39/rust-tools.nvim",
        config = function(client, bufnr)
            local config = require("jai.plugins.core.lsp.rust")
            require("rust-tools").setup(config.opts)
        end
        },



}
