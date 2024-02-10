-- [[ Theme ]]
local opt = vim.opt

opt.syntax = "ON" -- str:  Allow syntax highlighting
opt.termguicolors = true -- bool: If term supports ui color then enable

-- Only select 1
-- require("jai.plugins.configs.themes.dracula")
-- require("jai.plugins.configs.themes.material_ui")
-- require("jai.plugins.configs.themes.nord")
-- require("jai.plugins.configs.themes.nightfox")
require("jai.plugins.configs.themes.tokyonight")
