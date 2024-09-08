-- [[
--    DAP: Debug Adapter Protocol
--
--    repo: https://github.com/mfussenegger/nvim-dap
-- ]]
local core = require("jai.plugins.core.dap.core")
local nlua = require("jai.plugins.core.dap.nlua")

return vim.list_extend(core, nlua)
