require("jai.config.options")
require("jai.config.autocmds")
require("jai.config.keymaps")
require("jai.config.vars")

-- It's important that options is loaded before lazy (for mapleader)
require("jai.config.lazy")
