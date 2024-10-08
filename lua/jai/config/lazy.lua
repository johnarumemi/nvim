local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- NOTE: Below must be done after initial bootstrap of lazy above

-- Set global state to include the table
-- from the jai.util module.
--
-- Note that this automatically loads the
-- other modules wihin jai.util directory.
-- Access via JUtil.<module-name>
-- functions defined in jai.util/init.lua
-- are available at JUtil.<function-name>
_G.JUtil = require("jai.util")

-- Loads plugin specs
require("lazy").setup("jai.plugins.core", {
  defaults = {
    -- Default to true and then manually fix broken plugins
    lazy = true,
  },
  install = {
    missing = true,
  },
  change_detection = {
    notify = false,
  },
})

-- require("lazy").setup({
--   -- spec = {
--   --   -- add LazyVim and import its plugins
--   --   { "LazyVim/LazyVim", import = "lazyvim.plugins" },
--   --   -- import any extras modules here
--   --   -- { import = "lazyvim.plugins.extras.lang.typescript" },
--   --   -- { import = "lazyvim.plugins.extras.lang.json" },
--   --   -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
--   --   -- import/override with your plugins
--   --   { import = "plugins" },
--   -- },
--   defaults = {
--     -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
--     -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
--     lazy = false,
--     -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
--     -- have outdated releases, which may break your Neovim install.
--     version = false, -- always use the latest git commit
--     -- version = "*", -- try installing the latest stable version for plugins that support semver
--   },
--   -- install = { colorscheme = { "tokyonight", "habamax" } },
--   -- checker = { enabled = true }, -- automatically check for plugin updates
--   -- performance = {
--   --   rtp = {
--   --     -- disable some rtp plugins
--   --     disabled_plugins = {
--   --       "gzip",
--   --       -- "matchit",
--   --       -- "matchparen",
--   --       -- "netrwPlugin",
--   --       "tarPlugin",
--   --       "tohtml",
--   --       "tutor",
--   --       "zipPlugin",
--   --     },
--   --   },
--   -- },
-- })
