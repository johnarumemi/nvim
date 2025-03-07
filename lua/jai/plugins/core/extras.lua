return {

  {
    -- [[ Neorg ]]
    -- repo: https://github.com/nvim-neorg/neorg
    "nvim-neorg/neorg",
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    init = function()
      local config = require("jai.plugins.configs.neorg_config")

      config.init()
    end,
    config = function()
      local config = require("jai.plugins.configs.neorg_config")
      require("neorg").setup(config.opts)
    end,
  },
  {
    "max397574/neorg-contexts",
    dependencies = { "nvim-neorg/neorg" },
  },
  {
    "benlubas/neorg-conceal-wrap",
    dependencies = { "nvim-neorg/neorg" },
  },
  {
    -- [[ Markdown Preview ]]
    -- repo: https://github.com/iamcco/markdown-preview.nvim
    "iamcco/markdown-preview.nvim",
    -- Lazy-load on command
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    -- Lazy-load on filetype
    ft = { "markdown" },
    -- install with yarn
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    config = function()
      require("jai.plugins.configs.markdown_preview_config")
    end,

    -- below are syntax highlighter plugins
    -- for Mermaid and PlantUML respectively
    --
    -- vim-diagram is a syntax plugin for Mermaid.js diagrams.
    -- The file type must be set to sequence or the file extensions
    -- must be in *.seq, or *.sequence.
    -- plantuml-syntax is a syntax plugin for PlantUML diagrams.
    -- The file type must be set to plantuml, or the file extensions
    -- must be in .pu,*.uml,*.plantuml,*.puml,*.iuml.
    dependencies = { "zhaozg/vim-diagram", "aklt/plantuml-syntax", "folke/which-key.nvim" },
  },
  {
    -- repo: https://github.com/hedyhli/markdown-toc.nvim
    "hedyhli/markdown-toc.nvim",
    ft = "markdown", -- Lazy load on markdown filetype
    cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
    opts = {
      {
        headings = {
          -- Include headings before the ToC (or current line for `:Mtoc insert`).
          -- Setting to true will include headings that are defined before the ToC
          -- position to be included in the ToC.
          before_toc = false,
        },

        -- Table or boolean. Set to true to use these defaults, set to false to disable completely.
        -- Fences are needed for the update/remove commands, otherwise you can
        -- manually select ToC and run update.
        fences = {
          enabled = true,
          -- These fence texts are wrapped within "<!-- % -->", where the '%' is
          -- substituted with the text.
          start_text = "mtoc-start",
          end_text = "mtoc-end",
          -- An empty line is inserted on top and below the ToC list before the being
          -- wrapped with the fence texts, same as vim-markdown-toc.
        },

        -- Enable auto-update of the ToC (if fences found) on buffer save
        auto_update = true,

        toc_list = {
          -- string or list of strings (for cycling)
          -- If cycle_markers = false and markers is a list, only the first is used.
          -- You can set to '1.' to use a automatically numbered list for ToC (if
          -- your markdown render supports it).
          markers = "*",
          cycle_markers = false,
          -- Example config for cycling markers:
          ----- markers = {'*', '+', '-'},
          ----- cycle_markers = true,
        },
      },
    },
  },
  {
    -- repo: https://github.com/Allaman/emoji.nvim
    "allaman/emoji.nvim",
    version = "1.0.0", -- optionally pin to a tag
    ft = { "markdown", "norg" }, -- adjust to your needs
    dependencies = {
      -- optional for nvim-cmp integration
      "hrsh7th/nvim-cmp",
      -- optional for telescope integration
      "nvim-telescope/telescope.nvim",
      -- for keymaps
      "folke/which-key.nvim",
    },
    opts = {
      -- default is false
      enable_cmp_integration = true,
    },
    config = function(_, opts)
      require("emoji").setup(opts)
      local wk = require("which-key")
      -- optional for telescope integration
      local ts = require("telescope").load_extension("emoji")

      wk.add({
        { "<leader>fe", ts.emoji, desc = "[F]ind [E]moji", mode = "n" },
      })
    end,
  },
}
