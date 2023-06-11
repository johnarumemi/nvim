-- [[ plugins.lua ]]

-- uncomment to make use of utility functions
-- local utils = require("jai.utils")

local fn = vim.fn

-- below path should resolve to '$HOME/.config/nvim/site/pack'
local packer_path = vim.fn.stdpath("config") .. "/site/pack"
local install_path = packer_path .. "/packer/start/packer.nvim"

-- Clone packer if not present in install path
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end

-- add packer plugin
vim.cmd([[packadd packer.nvim]])

-- Auto recompile packages whenever this file is changed
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- load packer module each time Neovim is started
-- sets package root to location where Packer repo was cloned
return require("packer").startup({
	function(use)
		-- [[ Plugins Go Here ]]

		-- Packer can manage itself
		use("wbthomason/packer.nvim")

		-- LSP
		use({
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		})

		-- LSP config for rust_analyzer nvim-lspconfig
		use("simrat39/rust-tools.nvim")

		-- For each plugin that we add to packer, we delcare a `use-package` statement
		-- The below is the form taken for packages installed from github
		use({
			"nvim-tree/nvim-tree.lua",
			branch = "master",
			requires = {
				"nvim-tree/nvim-web-devicons", -- optional, for file icons
			},
			config = function()
				require("jai.plugins.nvim_tree_config")
			end,
		})

		-- Can't get startify to work on work computer
		use({ "mhinz/vim-startify", disable = true }) -- start screen

		use({
			"glepnir/dashboard-nvim",
			disable = false,
			event = "VimEnter",
			config = function()
				local config = require("jai.plugins.dashboard_config")
				require("dashboard").setup(config.opts)
			end,
			requires = { "nvim-tree/nvim-web-devicons" },
		})

		use({ "DanilaMihailov/beacon.nvim" }) -- cursor jump

		use({
			"nvim-lualine/lualine.nvim", -- statusline
			requires = {
				"nvim-tree/nvim-web-devicons",
				opt = true,
			},
		})

		use({
			"folke/which-key.nvim",
			disable = false,
			config = function()
				vim.o.timeout = true
				vim.o.timeoutlen = 300
				local config = require("jai.plugins.which_key_config")
				require("which-key").setup(config.opts)

				-- other generl keymappings
				require("jai.plugins.general_keymaps")
			end,
		})

		-- open current line in web
		-- <leader>g to view options
		use("ruanyl/vim-gh-line")

		-- [[ Themes ]]
		use("Mofiqul/dracula.nvim")
		use("marko-cerovac/material.nvim")
		use("shaunsingh/nord.nvim")
		use("EdenEast/nightfox.nvim")
		use({ "folke/tokyonight.nvim", branch = "main" })

		-- [[ Other ]]
		-- use({
		-- 	"akinsho/bufferline.nvim",
		-- 	tag = "v3.*",
		-- 	requires = "nvim-tree/nvim-web-devicons",
		-- 	config = function()
		-- 		require("bufferline").setup({})
		-- 	end,
		-- })

		use({
			"romgrk/barbar.nvim",
			tag = "v1.6.*",
			requires = {
				"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
				"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
			},
			config = function()
				require("barbar").setup()
				require("jai.plugins.barbar_config")
			end,
		})

		-- [[ Development ]]
		use({
			"nvim-telescope/telescope.nvim", -- fuzzy finder
			requires = { "nvim-lua/plenary.nvim" },
		})
		use({ "majutsushi/tagbar" }) -- code structure
		use({
			"Yggdroot/indentLine",
			disable = true,
			config = function()
				require("jai.plugins.indent_line_config")
			end,
		}) -- see indentation
		use({ "tpope/vim-fugitive" }) -- git integration
		use({ "junegunn/gv.vim" }) -- commit history
		use({ "windwp/nvim-autopairs" }) -- automatically create pair of parenthes

		-- https://github.com/lewis6991/gitsigns.nvim
		use({
			"lewis6991/gitsigns.nvim",
			tag = "v0.6",
			config = function()
				local gitsigns_config = require("jai.plugins.gitsigns_config")
				require("gitsigns").setup(gitsigns_config.config)
			end,
		})

		-- https://github.com/terrortylor/nvim-comment
		use({
			"terrortylor/nvim-comment",
			config = function()
				local config = require("jai.plugins.nvim_comment_config")
				require("nvim_comment").setup(config.opt)
			end,
		})

		-- nvim-treesitter
		-- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim
		use({
			"nvim-treesitter/nvim-treesitter",
			run = function()
				local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
				ts_update()
			end,
		})

		-- START: Taken from https://sharksforarms.dev/posts/neovim-rust/
		-- used within jai.capabilities.lua for LSP capabilities

		-- Visualize lsp progress
		use({
			"j-hui/fidget.nvim",
			config = function()
				require("fidget").setup() -- note how setup is called straight away
			end,
		})

		-- [[ Neorg ]]
		-- repo: https://github.com/nvim-neorg/neorg
		use({
			"nvim-neorg/neorg",
			tag = "v4.*",
			-- ft = "norg", -- load only on entering a .norg file
			after = { "nvim-treesitter", "which-key.nvim" },
			-- run = ":Neorg sync-parsers"
			config = function()
				local config = require("jai.plugins.neorg_config")
				require("neorg").setup(config.opts)
			end,
			requires = "nvim-lua/plenary.nvim",
		})

		-- Autocompletion framework
		use("hrsh7th/nvim-cmp")
		use({
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
			after = { "hrsh7th/nvim-cmp" },
			requires = { "hrsh7th/nvim-cmp" },
		})

		use({
			"jose-elias-alvarez/null-ls.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				require("jai.plugins.null_ls_config")
			end,
		})

		--- END

		use({
			"simrat39/symbols-outline.nvim",
			config = function()
				require("symbols-outline").setup()
			end,
		})

		-- Debugging
		use("nvim-lua/plenary.nvim")

		use("mfussenegger/nvim-dap")
	end,
	config = {
		package_root = packer_path,
	},
})
