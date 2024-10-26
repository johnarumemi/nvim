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
