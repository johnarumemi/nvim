local core = require("jai.plugins.core.lsp.core")
local rust = require("jai.plugins.core.lsp.rust")
local list = require("mason-core.functional.list")

local cpp = require("jai.plugins.core.lsp.cpp")

local output = list.concat(list.concat(core, rust), cpp)
-- local length = list.length(output)

return output
