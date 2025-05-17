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
  asm_lsp = JUtil.os.is_mac() and {} or nil,

  -- Rust: uses a specific plugin

  -- Nix
  nil_ls = {
    settings = {
      ["nil"] = {
        formatting = {
          -- ensure nixfmt is installed first.
          -- It can't be installed with Mason on OSX at the moment.
          command = { "nixfmt" },
        },
      },
    },

    on_attach = function(_, bufnr)
      -- update options for bash files
      buf_set_option(bufnr, "shiftwidth", 2) -- Size of an indent
      buf_set_option(bufnr, "softtabstop", 2) -- Number of spaces tabs count for in insert mode
      buf_set_option(bufnr, "tabstop", 2) -- Number of spaces tabs count for
    end,
  },

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
        -- use to prevent the LSP warnings for undefined `vim` global variable
        -- from appearing.
        diagnostics = {
          globals = { "vim" },
        },
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

  -- only available on Mac OS for now, this is more due to an issue
  -- in how I was setting things up within Colima VM though.
  ruff = JUtil.os.is_mac() and {} or nil,

  -- Typescript language-server
  -- also works for any standard javascript filetype
  ts_ls = {
    allow_formatting = false,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  -- Linting only
  -- filetypes: { "javascript", "javascriptreact", "javascript.jsx" }
  --
  -- update: 09/03/2025 - Changed some settings based on
  -- this blog: https://blog.ffff.lt/posts/typescript-and-neovim-lsp-2024/
  eslint = {
    settings = {
      packageManager = "yarn",
    },
    ---@diagnostic disable-next-line: unused-local
    on_attach = function(client, bufnr)
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
  yamlls = {
    settings = {
      yaml = {
        format = { enable = true, printWidth = 100 },
        validate = true,
      },
    },
  },

  -- TOML
  -- repo: https://github.com/tamasfe/taplo
  taplo = {},

  -- Protobufs:
  -- ERROR: appears to be broken at the moment and fails to install
  -- mason-lspconfig will install the mason Protobu language-server
  -- bufls = {},

  -- C/C++
  -- WARNING: neocmake requires nightly rust toolchain, else it gives below error,
  -- ```
  -- error[E0658]: use of unstable library feature 'lazy_cell'
  -- ```
  -- neocmake = {},

  -- Ensure mason installs the server
  clangd = JUtil.os.is_mac() and require("jai.plugins.core.lsp.cpp").clangd or nil,
}

function M.default_on_attach(client, buf)
  -- Plugin specific extensions (if applicable)]

  -- local server = M.servers[client.name] or {}

  vim.debug("Running default on_attach for server: " .. client.name, { title = title })

  -- Disable semantic tokens in VS Code to avoid conflicts with VS Code's own tokens
  if vim.g.vscode then
    client.server_capabilities.semanticTokensProvider = nil
  end

  -- call default on_attach
  require("jai.plugins.core.lsp.on_attach").on_attach(client, buf)

  -- if server has an on_attach already, call it
  -- Commented out: it is causing on-attach to be called twice
  -- if server.on_attach then
  --   server.on_attach(client, buf)
  -- end
end

function M.configure_servers()
  -- Skip LSP server configuration entirely if in VS Code
  if vim.g.vscode then
    vim.notify("Skipping LSP server configuration in VS Code", vim.log.levels.INFO)
    return
  end

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
