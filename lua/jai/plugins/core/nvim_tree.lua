local opts = {
  view = {
    width = 30,
  },
  update_focused_file = {
    enable = true,
    -- 	update_root = true,
  },
  filters = {
    dotfiles = true,
    custom = { "node_modules", "__pycache__" },
  },
}

return {
  {
    "nvim-tree/nvim-tree.lua",
    -- this should always be loaded and not lazy loaded
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/which-key.nvim" },
    opts = opts,
    config = function()
      require("nvim-tree").setup(opts)
      local wk = require("which-key")

      wk.register({
        --
        -- <leader>n
        --
        n = { [[:NvimTreeToggle<CR>]], "Toggle Tree" },
      }, { prefix = "<leader>" })
    end,
  },
  -- if some code requires a module from an unloaded plugin, it will be automatically loaded.
  -- So for api plugins like devicons, we can always set lazy=true
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
