return {

  -- Autocompletion framework
  -- This should get loaded first, then the one defined in the lsp modue
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
      { "hrsh7th/vim-vsnip" },
      -- Optional  -> Icons in autocompletion
      { "onsails/lspkind.nvim" },
    },
    -- returns a table, hence will parent specs, so be careful of loading order
    opts = function()
      vim.debug("InsertEnter: running nvim-cmp main opts setup", { title = "Completion" })
      -- Setup code completion for LSP
      -- from https://sharksforarms.dev/posts/neovim-rust/

      local lspkind = require("lspkind")

      -- Setup Completion
      -- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
      local cmp = require("cmp")

      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end

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
          -- ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end),

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

          -- Copilot Source
          { name = "copilot", group_index = 2 },

          -- Other Sources
          { name = "nvim_lsp", group_index = 2 },
          { name = "vsnip", group_index = 2 },
          { name = "path", group_index = 2 },
          { name = "buffer", group_index = 2 },

          -- display function signatures with current parameter emphasized
          { name = "nvim_lsp_signature_help", group_index = 2 },

          -- complete neovim's Lua runtime API such vim.lsp.*
          { name = "nvim_lua", keyword_length = 2, group_index = 2 },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          -- experimenting with below with lspkind and Copilot
          format = lspkind.cmp_format({
            mode = "symbol",
            max_width = 50,
            symbol_map = { Copilot = "" },
            -- when popup menu exceed maxwidth, the truncated part would show
            -- ellipsis_char instead
          }),
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            -- Prioritize copilot_cmp in completion list
            require("copilot_cmp.comparators").prioritize,

            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      }
    end,
  },
  {

    -- https://github.com/nvimtools/none-ls.nvim/issues/58
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvimtools/none-ls-extras.nvim", "nvim-lua/plenary.nvim", "mason.nvim" },
    opts = function()
      local config = require("jai.plugins.configs.none_ls_config")
      return config.opts
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  {
    --- repo: https://github.com/folke/trouble.nvim
    -- NOTE: originally, the below config was taken from LazyVim
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    dependencies = { "folke/which-key.nvim" },
    opts = {
      modes = {
        lsp = {
          win = { position = "bottom" },
        },
      },
    },
    init = function()
      local wk = require("which-key")

      wk.add({
        { "<leader>x", group = "Trouble Diagnostics" },
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
        { "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
        { "<leader>xS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
        { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
        { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
        {
          "[q",
          function()
            if require("trouble").is_open() then
              require("trouble").prev({ skip_groups = true, jump = true })
            else
              local ok, err = pcall(vim.cmd.cprev)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
          end,
          desc = "Previous Trouble/Quickfix Item",
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
          desc = "Next Trouble/Quickfix Item",
        },
      })
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
  {
    -- code structure
    -- See docs/wiki below for usage with Rust,
    -- [1]: https://github.com/preservim/tagbar/wiki#rust
    "majutsushi/tagbar",
    event = { "LspAttach" },
    ft = { "rs", ".py", ".json", ".tsx", ".jsx", ".js" },
    config = function()
      local wk = require("which-key")

      wk.add({
        { "<leader>tb", ":TagbarToggle<CR>", desc = "Tagbar Toggle" },
      })

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

  {
    -- Allow vscode style snippets to be used with native neovim snippets vim.snippet.
    -- repo: https://github.com/garymjr/nvim-snippets
    "garymjr/nvim-snippets",
    dependencies = {
      -- Snippets collection for a set of different programming languages.
      -- repo: https://github.com/rafamadriz/friendly-snippets
      "rafamadriz/friendly-snippets",
    },
    opts = {
      friendly_snippets = true,
    },
    keys = {
      {
        "<Tab>",
        function()
          if vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
            return
          end
          return "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<Tab>",
        function()
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        end,
        expr = true,
        silent = true,
        mode = "s",
      },
      {
        "<S-Tab>",
        function()
          if vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
            return
          end
          return "<S-Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
  },
}
