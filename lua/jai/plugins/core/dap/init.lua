local core = require("jai.plugins.core.dap.core")
local nlua = require("jai.plugins.core.dap.nlua")

-- force: keep rightmost table (nlua)
-- keep: keep leftmost table (core)
-- error: raise an error if there are conflicting keys
--
-- below should be an array of dicts anyway, so should be fine
return vim.list_extend(core, nlua)
-- return core
