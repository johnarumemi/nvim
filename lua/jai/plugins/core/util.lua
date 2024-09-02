-- General purpose utility plugins

return {

  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  { "nvim-lua/plenary.nvim" },

  -- if some code requires a module from an unloaded plugin, it will be automatically loaded.
  -- So for api plugins like devicons, we can always set lazy=true
  { "nvim-tree/nvim-web-devicons", lazy = true },

  { "DanilaMihailov/beacon.nvim" }, -- cursor jump

  -- Session management. This saves your session in the background,
  -- keeping track of open buffers, window arrangement, and more.
  -- You can restore sessions when returning through the dashboard.
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
      { "<leader>h", group = "Persistence" },
      -- load the session for the current directory
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      -- select a session to load
      { "<leader>qS", function() require("persistence").select() end, desc = "Select Session to restore" },
      -- load the last session
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      -- stop Persistence => session won't be saved on exit
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
}
