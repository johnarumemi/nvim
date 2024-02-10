return {

		-- Autocompletion framework
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release was too long ago
        dependencies = {
			-- cmp LSP completion
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-nvim-lua",
			-- cmp Snippet completion
			"hrsh7th/cmp-vsnip",
			-- cmp Path completion
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			-- Snippet engine
			"hrsh7th/vim-vsnip",

        }
    },

    {

			"nvimtools/none-ls.nvim",
event = { "BufReadPre", "BufNewFile" },
            dependencies = {
"nvim-lua/plenary.nvim", "mason.nvim" },

            config = function()

				local config = require("jai.plugins.configs.none_ls_config")


                require("null-ls").setup(config.opts)

            end
    }
    
}
