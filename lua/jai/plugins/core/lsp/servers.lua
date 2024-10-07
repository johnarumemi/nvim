-- [[ LSP Client Setup ]]
-- NOTE: Use repo to see server names available
-- repo: https://github.com/williamboman/mason-lspconfig.nvim
-- Some LSP's are setup via other plugins:
-- rust: setup by rust-tools. see rust.lua for setup configuration
--
-- Setup all your LSP servers here.

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
  clangd = {
    keys = {
      { "<localleader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
    },
    root_dir = function(fname)
      return require("lspconfig.util").root_pattern(
        "Makefile",
        "configure.ac",
        "configure.in",
        "config.h.in",
        "meson.build",
        "meson_options.txt",
        "build.ninja"
      )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(fname) or require(
        "lspconfig.util"
      ).find_git_ancestor(fname)
    end,
    capabilities = {
      offsetEncoding = { "utf-16" },
    },
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
  },
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
-- function M.on_attach_autocmd(on_attach)
--   vim.api.nvim_create_autocmd("LspAttach", {
--     callback = function(args)
--       local buffer = args.buf
--       local client = vim.lsp.get_client_by_id(args.data.client_id)
--       on_attach(client, buffer)
--     end,
--   })
-- end

-- function M.get_servers()
-- end

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
      local original_on_attach = server_opts["on_attach"]
      server_opts["on_attach"] = function(client, bufnr)
        M.default_on_attach(client, bufnr)
        original_on_attach(client, bufnr)
      end
    else
      server_opts["on_attach"] = M.default_on_attach
    end

    lspconfig[server].setup(server_opts)
  end
end

return M
