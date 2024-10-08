local list = require("mason-core.functional.list")

local core = require("jai.plugins.core.lsp.core")

local rust = require("jai.plugins.core.lsp.rust")
local cpp = require("jai.plugins.core.lsp.cpp")

local output = list.concat(list.concat(core, rust), cpp.plugin_specs)

return output
