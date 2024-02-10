local M = {}

M.autoformat = false

local util = require("ldw.util")

function M.toggle_autoformat()
  M.autoformat = not M.autoformat

  if M.autoformat then
    util.info("Autoformat enabled", { title = "Autoformat" })
  else
    util.info("Autoformat disabled", { title = "Autoformat" })
  end
end

function M.format()
  vim.lsp.buf.format()
end

function M.autoformat()
  if M.autoformat then
    M.format()
  end
end

function M.server_conf_allows_formatting(server_conf)
  -- nil or true indicate it's allowed
  return server_conf.allow_formatting ~= false
end

function M.on_attach(client, buf, server_conf)
  if
      client.config
      and client.config.capabilities
      and client.config.capabilities.documentFormattingProvider == false
  then
    return
  end

  if not M.server_conf_allows_formatting(server_conf) then
    return
  end

  if client.supports_method("textDocument/formatting") then
    -- Format on write
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
      buffer = buf,
      callback = M.autoformat,
    })
  end
end

return M
