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
    -- [[ neodev ]]
    -- repo: https://github.com/folke/neodev.nvim
    -- doc on Annotations: https://github.com/LuaLS/lua-language-server/wiki/Annotations
    "folke/neodev.nvim",
    opts = {},
  },
  {
    --- repo: https://github.com/folke/trouble.nvim
    -- NOTE: below config was taken from LazyVim
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
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
