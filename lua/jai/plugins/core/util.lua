-- General purpose utility plugins

return {

  { "nvim-lua/plenary.nvim" },

  { "DanilaMihailov/beacon.nvim" }, -- cursor jump

  {
    -- [[ Neorg ]]
    -- repo: https://github.com/nvim-neorg/neorg

    "nvim-neorg/neorg",
    version = false,
    -- Lazy-load on filetype
    ft = { "norg" },
    -- build = ":Neorg sync-parsers",
    cmd = "Neorg",
    priority = 30, -- treesitter is on default priority of 50, neorg should load after it.

    -- WARNING: Getting Neorg + treesitter to work is a real pain.
    -- See the below comment / thread for information on below workaround
    -- github: https://github.com/nvim-neorg/tree-sitter-norg/issues/7#issuecomment-1542743399
    build = function()
      local shell = require("nvim-treesitter.shell_command_selectors")
      local install = require("nvim-treesitter.install")

      -- save the original functions
      local select_executable = shell.select_executable
      local compilers = install.compilers

      -- temporarily patch treesitter install logic
      local cc = "clang++ -std=c++11"
      function shell.select_executable(executables)
        return vim.tbl_filter(function(c) ---@param c string
          return c ~= vim.NIL and (vim.fn.executable(c) == 1 or c == cc)
        end, executables)[1]
      end
      install.compilers = { cc }

      -- install norg parsers
      install.commands.TSInstallSync["run!"]("norg") -- or vim.cmd [[ :TSInstallSync! norg ]]

      -- restore the defaults back
      shell.select_executable = select_executable
      install.compilers = compilers
    end,
    dependencies = { "nvim-cmp", "folke/which-key.nvim", "nvim-lua/plenary.nvim" },
    -- dependencies = { "nvim-treesitter", "folke/which-key.nvim", "nvim-lua/plenary.nvim", },
    -- run = ":Neorg sync-parsers"
    config = function()
      local config = require("jai.plugins.configs.neorg_config")
      require("neorg").setup(config.opts)
    end,
  },
  {
    -- [[ Markdown Preview ]]
    -- repo: https://github.com/iamcco/markdown-preview.nvim
    -- ensure you have node.js and yarn installed
    -- and available in your path

    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_filetypes = { "markdown", "norg" }
      require("jai.plugins.configs.markdown_preview_config")
    end,
    -- Lazy-load on filetype
    ft = { "markdown", "norg" },

    -- Lazy-load on command
    cmd = { "MarkdownPreview" },
    -- below are syntax highlighter plugins
    -- for Mermaid and PlantUML respectively
    --
    -- vim-diagram is a syntax plugin for Mermaid.js diagrams.
    -- The file type must be set to sequence or the file extensions
    -- must be in *.seq, or *.sequence.
    -- plantuml-syntax is a syntax plugin for PlantUML diagrams.
    -- The file type must be set to plantuml, or the file extensions
    -- must be in .pu,*.uml,*.plantuml,*.puml,*.iuml.
    dependencies = { "zhaozg/vim-diagram", "aklt/plantuml-syntax" },
  },
}
