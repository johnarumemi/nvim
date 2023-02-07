-- [[ Theme ]]
local opt = vim.opt

opt.syntax = "ON"                -- str:  Allow syntax highlighting
opt.termguicolors = true         -- bool: If term supports ui color then enable

-- Only select 1
-- require("jai.themes.dracula")
require("jai.themes.material_ui")

