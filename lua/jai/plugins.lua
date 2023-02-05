-- [[ plugins.lua ]]

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

return require('packer').startup({function(use)
  -- [[ Plugins Go Here ]]

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'


  -- Mason
  -- LSP Client Configs
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }

  -- LSP config for rust_analyzer nvim-lspconfig
  use('simrat39/rust-tools.nvim')

  -- For each plugin that we add to packker, we delcare a `use-package` statement
  -- The below is the form taken for packages installed from github
  use {
    'nvim-tree/nvim-tree.lua',
    branch="master",
     requires = {
        'nvim-tree/nvim-web-devicons', -- optional, for file icons
    }
  }

  use { 'mhinz/vim-startify' }                       -- start screen
  use { 'DanilaMihailov/beacon.nvim' }               -- cursor jump

  use {
    'nvim-lualine/lualine.nvim',                     -- statusline
    requires =
        {
          'nvim-tree/nvim-web-devicons',
          opt = true
        }
  }

  -- Theme
  use 'Mofiqul/dracula.nvim'


  -- [[ Dev ]]
  use {
    'nvim-telescope/telescope.nvim',                 -- fuzzy finder
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use { 'majutsushi/tagbar' }                        -- code structure
  use { 'Yggdroot/indentLine' }                      -- see indentation
  use { 'tpope/vim-fugitive' }                       -- git integration
  use { 'junegunn/gv.vim' }                          -- commit history
  use { 'windwp/nvim-autopairs' }

  -- nvim-treesitter
  -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim
  use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
  }

  -- LSP based code folding
  -- https://github.com/kevinhwang91/nvim-ufo
  -- https://gist.github.com/mengwangk/a9a7d3bd855d3523b3a365236fc63290#file-plugins-lua
  use {
  "kevinhwang91/nvim-ufo",
  opt = true,
  event = { "BufReadPre" },
  wants = { "promise-async" },
  requires = "kevinhwang91/promise-async",
  config = function()
      require("ufo").setup {}

      -- options for code foldng
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99 -- also seen this set to -1 or 99
      vim.o.foldenable = true

      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    end,
  }
  -- START: Taken from https://sharksforarms.dev/posts/neovim-rust/
  -- used within jai.capabilities.lua for LSP capabilities

  -- Visualize lsp progress
  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()  -- note how setup is called straight away
    end
  })

  -- Autocompletion framework
  -- completion framework
  use("hrsh7th/nvim-cmp")
  use({
    -- cmp LSP completion
    "hrsh7th/cmp-nvim-lsp",

    'hrsh7th/cmp-nvim-lsp-signature-help',

    'hrsh7th/cmp-nvim-lua',

    -- cmp Snippet completion
    "hrsh7th/cmp-vsnip",

    -- cmp Path completion
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",

    -- Snippet engine
    'hrsh7th/vim-vsnip',

    after = { "hrsh7th/nvim-cmp" },
    requires = { "hrsh7th/nvim-cmp" },
  })

  --- END


  -- Debugging
  use 'nvim-lua/plenary.nvim'
  use 'mfussenegger/nvim-dap'

end,
config = {
  package_root = vim.fn.stdpath('config') .. '/site/pack'
}})

