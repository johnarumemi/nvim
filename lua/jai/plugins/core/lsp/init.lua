-- LSP-related plugins

-- Import all LSP plugin modules
local modules = {
  require("jai.plugins.core.lsp.core"),
  require("jai.plugins.core.lsp.rust"),
  require("jai.plugins.core.lsp.typescript"),
  require("jai.plugins.core.lsp.cpp").plugin_specs,
}

return JUtil.lib.merge_plugin_tables(modules)
