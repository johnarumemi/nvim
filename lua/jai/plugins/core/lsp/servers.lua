-- [[ LSP Client Setup ]]
-- NOTE: Use repo to see server names available
-- repo: https://github.com/williamboman/mason-lspconfig.nvim
-- Some LSP's are setup via other plugins:
-- rust: setup by rust-tools. see rust.lua for setup configuration
--
-- Setup all your LSP servers here.

local title = "LSP - Server Setup"

-- alias
local buf_set_option = function(buf, name, value)
  vim.api.nvim_set_option_value(name, value, { buf = buf })
end

local M = {}

M.servers = {
  -- Assembly
  asm_lsp = {},

  -- Rust: uses a specific plugin

  -- Lua
  -- mason package name = lua-language-server
  lua_ls = {
    telemetry = {
      enable = false,
    },

    -- we will use stylua (with null-ls)
    -- for formatting lua files
    settings = {
      Lua = {
        format = { enable = false },
      },
    },
    on_attach = function(_, bufnr)
      -- update options for lua files
      buf_set_option(bufnr, "shiftwidth", 2) -- Size of an indent
      buf_set_option(bufnr, "softtabstop", 2) -- Number of spaces tabs count for in insert mode
      buf_set_option(bufnr, "tabstop", 2) -- Number of spaces tabs count for
    end,
  },

  -- Python
  pyright = {
    on_attach = function(_, bufnr)
      -- update options for python files
      buf_set_option(bufnr, "shiftwidth", 4) -- Size of an indent
      buf_set_option(bufnr, "softtabstop", 4) -- Number of spaces tabs count for in insert mode
      buf_set_option(bufnr, "tabstop", 4) -- Number of spaces tabs count for
    end,
    settings = {
      pyright = {
        typeCheckingMode = "basic",
      },
    },
  },

  ruff = {},

  -- Typescript language-server
  -- also works for any standard javascript filetype
  ts_ls = {
    allow_formatting = false,
  },

  -- Linting only
  -- filetypes: { "javascript", "javascriptreact", "javascript.jsx" }
  eslint = {
    on_attach = function(_, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end,
  },
  -- Terraform
  terraform_lsp = {
    cmd = { "terraform-ls", "serve" },
  },
  -- Bash
  bashls = {

    on_attach = function(_, bufnr)
      -- update options for bash files
      buf_set_option(bufnr, "shiftwidth", 4) -- Size of an indent
      buf_set_option(bufnr, "softtabstop", 4) -- Number of spaces tabs count for in insert mode
      buf_set_option(bufnr, "tabstop", 4) -- Number of spaces tabs count for
    end,
  },

  -- SQL
  sqlls = {},

  -- Markdown
  marksman = {},

  -- Json
  -- mason-lspconfig will install the mason json-ls server
  jsonls = {},

  -- YAML
  -- mason-lspconfig will install the mason yaml-language-server
  yamlls = {},

  -- TOML
  -- repo: https://github.com/tamasfe/taplo
  taplo = {},

  -- Protobufs:
  -- ERROR: appears to be broken at the moment and fails to install
  -- mason-lspconfig will install the mason Protobu language-server
  -- bufls = {},

  -- C/C++
  neocmake = {},

  -- Ensure mason installs the server
  clangd = require("jai.plugins.core.lsp.cpp").clangd,

  -- repo: https://github.com/ranjithshegde/ccls.nvim
  -- lsp documentation: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ccls
  -- ccls = {
  --   filetypes = { "c", "cpp", "objc", "objcpp", "opencl" },
  --   -- disable capabilities if using clangd alongside ccls
  --   lsp = {
  --     server = {
  --       filetypes = { "c", "cpp", "objc", "objcpp", "opencl" },
  --       init_options = { cache = {
  --         directory = vim.fs.normalize("~/.cache/ccls/"),
  --       } },
  --       name = "ccls",
  --       cmd = { "ccls" },
  --       offset_encoding = "utf-32",
  --       root_dir = vim.fs.dirname(
  --         vim.fs.find({ "compile_commands.json", "compile_flags.txt", ".git" }, { upward = true })[1]
  --       ),
  --     },
  --     disable_capabilities = {
  --       completionProvider = true,
  --       documentFormattingProvider = true,
  --       documentRangeFormattingProvider = true,
  --       documentHighlightProvider = true,
  --       documentSymbolProvider = true,
  --       workspaceSymbolProvider = true,
  --       renameProvider = true,
  --       hoverProvider = true,
  --       codeActionProvider = true,
  --     },
  --     disable_diagnostics = true,
  --     disable_signature = true,
  --   },
  -- },
}

function M.default_on_attach(client, buf)
  -- Plugin specific extensions (if applicable)]

  -- local server = M.servers[client.name] or {}

  vim.debug("Running default on_attach for server: " .. client.name, { title = title })

  -- call default on_attach
  require("jai.plugins.core.lsp.on_attach").on_attach(client, buf)

  -- if server has an on_attach already, call it
  -- Commented out: it is causing on-attach to be called twice
  -- if server.on_attach then
  --   server.on_attach(client, buf)
  -- end
end

function M.configure_servers()
  local lspconfig = require("lspconfig")

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- for cpm_nvim_lsp
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  -- server: name of server
  -- extra_opts: options set for the server

  for server, extra_options in pairs(M.servers) do
    -- overwrite server_opts with our own capabilities
    local server_opts = vim.tbl_deep_extend("force", {
      capabilities = vim.deepcopy(capabilities),
    }, extra_options or {})

    if server_opts["on_attach"] ~= nil then
      -- Wrap the original on_attach function with our default on_attach
      local original_on_attach = server_opts["on_attach"]

      server_opts["on_attach"] = function(client, bufnr)
        M.default_on_attach(client, bufnr)

        vim.debug("Running custom  on_attach for server: " .. server, { title = title })
        original_on_attach(client, bufnr)
      end
    else
      -- Use the default on_attach since none was specified
      server_opts["on_attach"] = M.default_on_attach
    end

    vim.debug("Started  setup for server: " .. server, { title = title })
    lspconfig[server].setup(server_opts)
    vim.debug("Finished setup for server: " .. server, { title = title })
  end
end

return M
