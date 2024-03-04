return {
  {
    "zhenyangze/vim-bitoai",
    version = false,
    lazy = true,
    -- event = "VeryLazy",
    cmd = { "BitoAi start" },
    dependencies = { "folke/which-key.nvim" },
    config = function()
      local wk = require("which-key")

      wk.register({
        b = {
          name = "BitoAI",
          c = {
            name = "Check",
            ["c"] = { "[[:BitoAiCheck<CR>]]", "Check" },
            ["s"] = { "[[:BitoAiCheckStyle<CR>]]", "Check Style" },
          },
          g = {
            name = "Generate",
            ["g"] = { "[[:BitoAiGenerate<CR>]]", "Generate Code" },
            ["m"] = { "[[:BitoAiGenerateComment<CR>]]", "Generate Comment" },
            ["u"] = { "[[:BitoAiGenerateUnit<CR>]]", "Generate Unit" },
          },
        },
      }, { prefix = "<leader>", mode = { "n", "v" } })
    end,
  },
  {
    "github/copilot.vim",
    cmd = { "Copilot enable" },
    lazy = true,
    -- event = "VeryLazy",
    build = function()
      -- Not 100% sure if this is needed
      vim.cmd("Copilot setup")
    end,
  },
}
