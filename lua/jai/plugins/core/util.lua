-- General purpose utility plugins

return {

    {"nvim-lua/plenary.nvim"},

    {"DanilaMihailov/beacon.nvim"}, -- cursor jump

    {
		-- [[ Neorg ]]
		-- repo: https://github.com/nvim-neorg/neorg

			"nvim-neorg/neorg",
			version = false,
            -- Lazy-load on filetype
			ft = { "markdown", "norg" },
            build = ":Neorg sync-parsers",
            cmd = 'Neorg',
            priority = 30, -- treesitter is on default priority of 50, neorg should load after it.

			dependencies = { "nvim-treesitter", "folke/which-key.nvim", "nvim-lua/plenary.nvim", },
			-- run = ":Neorg sync-parsers"
			config = function()
				local config = require("jai.plugins.configs.neorg_config")
				require("neorg").setup(config.opts)
			end,
    },
    {
		-- [[ Markdown Preview ]]
		-- repo: https://github.com/iamcco/markdown-preview.nvim
		-- ensure you have node.js and yarn installed
		-- and available in your path

			"iamcco/markdown-preview.nvim",
			build = "cd app && npm install",
			config = function()
				vim.g.mkdp_filetypes = { "markdown", "norg" }
				require("jai.plugins.configs.markdown_preview_config")
			end,
            -- Lazy-load on filetype
			ft = { "markdown", "norg" },

            -- Lazy-load on command
			cmd = { "MarkdownPreview" },
			-- below are syntax highlighter plugins
			-- for Mermaid and PlantUML respectively
			--
			-- vim-diagram is a syntax plugin for Mermaid.js diagrams.
			-- The file type must be set to sequence or the file extensions
			-- must be in *.seq, or *.sequence.
			-- plantuml-syntax is a syntax plugin for PlantUML diagrams.
			-- The file type must be set to plantuml, or the file extensions
			-- must be in .pu,*.uml,*.plantuml,*.puml,*.iuml.
			dependencies = { "zhaozg/vim-diagram", "aklt/plantuml-syntax" },

    },

}
