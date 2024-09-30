return {

  {
    -- [[ Neorg ]]
    -- repo: https://github.com/nvim-neorg/neorg
    "nvim-neorg/neorg",
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    init = function()
      local wk = require("which-key")
      -- This should ensure the keymaps are available in every buffer/file type
      wk.add({
        { "<leader>w", group = "[neorg] Workspace" },
        { "<leader>wd", ":Neorg workspace<CR>", desc = "Open Default Workspace" },
        { "<leader>ww", ":Neorg workspace todo-work<CR>", desc = "Open Todo - Work" },
        { "<leader>wp", ":Neorg workspace todo-private<CR>", desc = "Open Todo - Private" },
        { "<leader>wr", ":Neorg workspace rust<CR>", desc = "Open Rust " },
      })
      -- create new highlight group for Neorg verbatim markups
      -- vim.cmd([[ highlight NeorgCustomVerbatim guifg=cyan ]])
    end,
    config = function()
      local config = require("jai.plugins.configs.neorg_config")
      require("neorg").setup(config.opts)
      -- vim.cmd([[ highlight link @neorg.markup.verbatim.norg NeorgCustomVerbatim ]])
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
}
