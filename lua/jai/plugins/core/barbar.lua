-- [[ barbar ]]
-- repo: https://github.com/romgrk/barbar.ngroup_namevim
-- when using iterm2, change following:
-- 1. goto profiles -> select a profile to apply changes to
-- 2. go to 'keys' tab
-- 3. set "Left Option Key" and/or "Right Option Key" to "Esc+"
--
-- The above will ensure the correct escape sequence is sent
-- by the "Option" key on a Mac so that is acts like "Alt"
-- on other keyboards. This will enable the <A-...> keymaps
-- below to work correctly.

return {

  "romgrk/barbar.nvim",
  version = "v1.6.*",
  lazy = false,
  dependencies = {
    "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
    "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
  },
  config = function()
    require("barbar").setup()

    -- loading in keymaps
    require("jai.plugins.configs.barbar_config")
  end,
}
