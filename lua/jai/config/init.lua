require("jai.config.options")
require("jai.config.vars")
require("jai.config.keymaps")
require("jai.config.commands")
require("jai.config.autocmds")

-- It's important that options is loaded before lazy (for mapleader)
require("jai.config.lazy")
