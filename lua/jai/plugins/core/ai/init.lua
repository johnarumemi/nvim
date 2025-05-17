-- AI-related plugins

local modules = {
  require("jai.plugins.core.ai.copilot"),
  require("jai.plugins.core.ai.copilot-chat"),
}

return JUtil.lib.merge_plugin_tables(modules)
