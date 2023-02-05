-- [[ LSP Setup ]]
-- setup all your LSP servers here. Ensure that you have required lspconfig first
-- Note: rust_analyzer is setup via rust-tools, so do not perform any setup
-- functionality here for rust.
local on_attach = require("jai.on_attach")
local capabilities = require("jai.capabilities")

local opt = vim.opt

-- Some LSP's are setup via other plugins:
-- rust: setup by rust-tools. see jai/rust.lua for setup configuration


-- After setting up mason-lspconfig you may set up servers 
-- via lspconfig
-- Note: this means setup client configurations against a lsp server
-- after all, lspconfig is just a collection of configurations.
-- the below accesses the rust_analyzer configurtion and calls it
-- setup{} function, which wraps around the lsp.start_client() function.

-- Lua
-- mason = lua-language-server
require("lspconfig").sumneko_lua.setup {
  on_attach=function(client, bufnr)

    -- apply default on_attach settings
    on_attach(client, bufnr)

    -- update options for lua files
    opt.shiftwidth = 2               -- num:  Size of an indent
    opt.softtabstop = 2              -- num:  Number of spaces tabs count for in insert mode
    opt.tabstop = 2                  -- num:  Number of spaces tabs count for

    end,
    capabilities=capabilities
}

-- Python
require("lspconfig").pyright.setup{
    capabilities=capabilities
}

-- Markdown
require("lspconfig").marksman.setup{
  on_attach=on_attach,
  capabilities=capabilities
}

