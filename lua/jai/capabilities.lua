-- LSP capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- for nvim-ufo: code folding
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

-- for cpm_nvim_lsp
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
-- capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true



return capabilities

