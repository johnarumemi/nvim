-- [[ LSP Setup ]]
-- repo: https://github.com/williamboman/mason-lspconfig.nvim
-- Use repo to see server names available
--
-- setup all your LSP servers here. Ensure that you have required lspconfig first
-- Note: rust_analyzer is setup via rust-tools, so do not perform any setup
-- functionality here for rust.
-- TODO: can this be scoped to a buffer specific option?
local opt = vim.opt

-- NOTE: Some LSP's are setup via other plugins:
-- rust: setup by rust-tools. see jai/rust.lua for setup configuration

-- After setting up mason-lspconfig you may set up servers
-- via lspconfig
-- Note: this means setup client configurations against a lsp server
-- after all, lspconfig is just a collection of configurations.
-- the below accesses the rust_analyzer configurtion and calls it
-- setup{} function, which wraps around the lsp.start_client() function.

-- Lua
-- mason package name = lua-language-server

local M = {}

M.servers = {
  -- Rust: uses rust-tools
  -- rust_analyzer = {
  --   settings = {
  --     ['rust-analyzer'] = {
  --       procMacros = {
  --         enable = true
  --       },
  --       cargo = {
  --         allFeatures = true
  --       },
  --       checkOnSave = {
  --         command = "clippy",
  --         -- To prevent check on save taking a lock on the target dir (blocking cargo build/run)
  --         extraArgs = { "--target-dir", "target/ra-check" },
  --       }
  --     }
  --   }
  -- },

  -- TODO: scope "opts" to current buffer only
  -- nvim_buf_set_option (see on_attach.lua)

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
    on_attach = function(client, bufnr)
      -- update options for lua files
      opt.shiftwidth = 2 -- num:  Size of an indent
      opt.softtabstop = 2 -- num:  Number of spaces tabs count for in insert mode
      opt.tabstop = 2 -- num:  Number of spaces tabs count for
    end,
  },

  -- Python
  -- pylsp = {
  --   settings = {
  --     pylsp = {
  --       plugins = {
  --         pycodestyle = {
  --           ignore = {},
  --           maxLineLength = 200
  --         }
  --       }
  --     }
  --   }
  -- },
  pyright = {
    on_attach = function(client, bufnr)
      -- update options for lua files
      opt.shiftwidth = 4 -- num:  Size of an indent
      opt.softtabstop = 4 -- num:  Number of spaces tabs count for in insert mode
      opt.tabstop = 4 -- num:  Number of spaces tabs count for
    end,
    settings = {
      pyright = {
        typeCheckingMode = "basic",
      },
    },
  },

  -- Typescript language-server
  -- also works for any standard javascript filetype
  tsserver = {
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

    on_attach = function(client, bufnr)
      -- update options for lua files
      opt.shiftwidth = 2 -- num:  Size of an indent
      opt.softtabstop = 2 -- num:  Number of spaces tabs count for in insert mode
      opt.tabstop = 2 -- num:  Number of spaces tabs count for
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

  -- Protobufs
  -- mason-lspconfig will install the mason Protobu language-server
  bufls = {},
}

function M.default_on_attach(client, buf)
  -- Plugin specific extensions (if applicable)]
  local server = M.servers[client.name] or {}

  -- require("ldw.plugins.lsp.format").on_attach(client, buf, server)
  -- require("ldw.plugins.lsp.keymaps").on_attach(client, buf, server)

  -- call default on_attach
  require("jai.plugins.core.lsp.on_attach").on_attach(client, buf)

  -- if server has an on_attach already, call it
  if server.on_attach then
    server.on_attach(client, buf)
  end
end

-- Create an autocmd to run on LspAttach that runs the default on_attach action
function M.on_attach_autocmd(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

-- function M.get_servers()
-- end

function M.configure_servers()
  local lspconfig = require("lspconfig")
  -- local capabilities = require("cmp_nvim_lsp")
  --     .default_capabilities(vim.lsp.protocol.make_client_capabilities())

  local capabilities = require("jai.plugins.core.lsp.capabilities")

  -- server: name of server
  -- extra_opts: options set for the server
  for server, extra_options in pairs(M.servers) do
    -- local server_opts = vim.tbl_deep_extend("force", {
    --   capabilities = vim.deepcopy(capabilities),
    -- }, extra_options or {})

    -- overwrite server_opts with our own capabilities
    local server_opts = vim.tbl_deep_extend("force", {
      capabilities,
    }, extra_options or {})

    if server_opts["on_attach"] ~= nil then
      local original_on_attach = server_opts["on_attach"]
      server_opts["on_attach"] = function(client, bufnr)
        original_on_attach(client, bufnr)
        M.default_on_attach(client, bufnr)
      end
    else
      server_opts["on_attach"] = M.default_on_attach
    end

    lspconfig[server].setup(server_opts)
  end
end

return M
