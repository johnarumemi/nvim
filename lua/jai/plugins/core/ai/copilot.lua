return {

  {
    -- INFO: Use `:help copilot` for documentation of setup of copilot-cmp
    -- repo: https://github.com/zbirenbaum/copilot.lua
    "zbirenbaum/copilot.lua",
    -- Disable Copilot in VS Code as it has its own Copilot extension
    enabled = function()
      return not vim.g.vscode
    end,
    cmd = { "Copilot" },
    event = { "InsertEnter" },
    config = function()
      require("copilot").setup({

        -- It is recommended to disable copilot.lua's suggestion and panel modules, as
        -- they can interfere with completions properly appearing in copilot-cmp. To do
        -- so, simply place the following in your copilot.lua config:
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    -- repo: https://github.com/zbirenbaum/copilot-cmp
    --
    -- turns `zbirenbaum/copilot.lu` into a completion source, rather than have
    -- it pollute your inline text insertions.
    --
    -- NOTE: part of configuring this involves adding it as a source to nvim-cmp.
    -- So if uninstalling, ensure that it is removed from there as well.
    "zbirenbaum/copilot-cmp",
    enabled = function()
      -- Disable Copilot CMP in VS Code
      return not vim.g.vscode
    end,
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    -- repo: https://github.com/AndreM222/copilot-lualine
    --
    -- add copilot status sign in lualine
    "AndreM222/copilot-lualine",
    -- Disable Copilot lualine in VS Code as it's not needed
    enabled = function()
      return not vim.g.vscode
    end,
  },
}
