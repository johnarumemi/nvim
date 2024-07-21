return {

  {
    -- [[ Neorg ]]
    -- repo: https://github.com/nvim-neorg/neorg
    "nvim-neorg/neorg",
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = function()
      local config = require("jai.plugins.configs.neorg_config")
      require("neorg").setup(config.opts)
    end,
  },

  {
    -- [[ Markdown Preview ]]
    -- repo: https://github.com/iamcco/markdown-preview.nvim
    "iamcco/markdown-preview.nvim",
    -- Lazy-load on command
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    -- Lazy-load on filetype
    ft = { "markdown", "norg" },
    build = function()
      vim.fn["mkdp#util#install"]()
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
}
