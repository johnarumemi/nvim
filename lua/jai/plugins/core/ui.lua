return {
    -- [[ Main dashboard ]]

    {
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
      "arkav/lualine-lsp-progress",
    },
    opts = {
      sections = {
        lualine_c = {
          "lsp_progress"
        }
      }
    },
  },
  {
    "arkav/lualine-lsp-progress"
  },

        
		-- [[ Themes ]]
        {"Mofiqul/dracula.nvim"},
        {"marko-cerovac/material.nvim"},
        {"shaunsingh/nord.nvim"},
        {"EdenEast/nightfox.nvim"},
		{ "folke/tokyonight.nvim", 
        version = "main",
        lazy = false,
        priority = 1000,
        config = function()
            require("jai.plugins.configs.themes.main")
        end
    }

}
