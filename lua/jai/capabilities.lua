-- LSP capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- for cpm_nvim_lsp
capabilities.textDocument.completion.completionItem.snippetSupport = true

return capabilities

