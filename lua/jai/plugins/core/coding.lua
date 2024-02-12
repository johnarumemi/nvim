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
    },
  },

  {

    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim", "mason.nvim" },
    opts = function()
      local config = require("jai.plugins.configs.none_ls_config")
      return config.opts
    end,
  },
  {

    -- [[ nvim-comment ]]
    -- Commenting out code
    -- repo: https://github.com/terrortylor/nvim-comment
    "terrortylor/nvim-comment",
    lazy = false,

    opts = {
      -- Linters prefer comment and line to have a space in between markers
      marker_padding = true,
      -- should comment out empty or whitespace only lines
      comment_empty = false,
      -- trim empty comment whitespace
      comment_empty_trim_whitespace = true,
      -- Should key mappings be created
      create_mappings = true,
      -- Normal mode mapping left hand side
      line_mapping = "gcc",
      -- Visual/Operator mapping left hand side
      operator_mapping = "gc",
      -- text object mapping, comment chunk,,
      comment_chunk_text_object = "ic",
      -- Hook function to call before commenting takes place
      hook = nil,
    },
    config = function(_, opts)
      -- need to use config for this, since module name
      -- uses underscore, rather than hyphen
      require("nvim_comment").setup(opts)
    end,
  },
}
