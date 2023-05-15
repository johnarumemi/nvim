local wk = require("which-key")

wk.register({
  --
  -- <leader>n
  --
  n = { [[:NvimTreeToggle<CR>]], "Toggle Tree" },
  --
  -- <leader>t
  --
  t = {
    name = "Toggle",
    i = { [[:IndentLinesToggle<CR>]], "Indent Lines Toggle" },
    b = { [[:TagbarToggle<CR>]], "Tagbar Toggle" },
  },
}, { prefix = "<leader>" })

local opts = {
  update_focused_file = {
    enable = true,
    update_root = true,
  },
}

require("nvim-tree").setup(opts)
