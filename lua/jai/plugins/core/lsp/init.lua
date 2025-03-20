local list = require("mason-core.functional.list")

local modules = {
  require("jai.plugins.core.lsp.core"),
  require("jai.plugins.core.lsp.rust"),
  require("jai.plugins.core.lsp.typescript"),
  require("jai.plugins.core.lsp.cpp").plugin_specs,
}

-- Concatenate all modules into a single list
local output = {}

for _, module in ipairs(modules) do
  output = list.concat(output, module)
end

return output
