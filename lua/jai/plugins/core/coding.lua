return {

  -- Autocompletion framework
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release was too long ago
    event = { "InsertEnter" },
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
    opts = function()
      -- Setup code completion for LSP
      -- from https://sharksforarms.dev/posts/neovim-rust/

      -- Setup Completion
      -- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
      local cmp = require("cmp")
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          -- scroll up and down in autocompletion window
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),

          -- Add tab support
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<Tab>"] = cmp.mapping.select_next_item(),

          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- TODO: not sure that below mapping works
          ["<C-Space>"] = cmp.mapping.complete(),

          -- close autocompletion window
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
        },
        -- Installed sources
        sources = {
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "path" },
          { name = "buffer" },

          -- display function signatures with current parameter emphasized
          { name = "nvim_lsp_signature_help" },

          -- complete neovim's Lua runtime API such vim.lsp.*
          { name = "nvim_lua", keyword_length = 2 },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          fields = { "menu", "abbr", "kind" },
          format = function(entry, item)
            local menu_icon = {
              nvim_lsp = "λ",
              vsnip = "⋗",
              buffer = "Ω",
              path = "🖫",
            }
            item.menu = menu_icon[entry.source.name]
            return item
          end,
        },
      }
    end,
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
  {
    -- code structure
    -- See docs/wiki below for usage with Rust,
    -- [1]: https://github.com/preservim/tagbar/wiki#rust
    "majutsushi/tagbar",
    event = { "LspAttach" },
    ft = {"rs", ".py", ".json", ".tsx", ".jsx", ".js"},
    config = function()
      local wk = require("which-key")

      wk.register({
        --
        -- <leader>t
        t = {
          name = "Toggle",
          b = { [[:TagbarToggle<CR>]], "Tagbar Toggle" },
        },
      }, { prefix = "<leader>" })

      -- vim.g.rust_use_custom_ctags_defs = 1

      vim.g.tagbar_type_rust = {
        ctagsbin = "/opt/homebrew/bin/ctags",
        ctagstype = "rust",
        kinds = {
          "n:modules",
          "s:structures:1",
          "i:interfaces",
          "c:implementations",
          "f:functions:1",
          "g:enumerations:1",
          "t:type aliases:1:0",
          "C:constants:1:0",
          "M:macros:1",
          "m:fields:1:0",
          "e:enum variants:1:0",
          "P:methods:1",
        },
        sro = "::",
        kind2scope = {
          n = "module",
          s = "struct",
          i = "interface",
          c = "implementation",
          f = "function",
          g = "enum",
          t = "typedef",
          v = "variable",
          M = "macro",
          m = "field",
          e = "enumerator",
          P = "method",
        },
      }
    end,
  },
}
