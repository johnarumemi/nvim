local title = "C/C++ LSP"

-- lsp config for C/C++ using clangd
-- ensure to have this added to table of servers in `../servers.lua`
local clangd = {
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

  on_attach = function(_, buf)
    local msg = string.format("OnAttach: Attaching clangd to buffer %d", buf)
    vim.debug(msg, { title = title })

    require("clangd_extensions.inlay_hints").setup_autocmd()
    require("clangd_extensions.inlay_hints").set_inlay_hints()
  end,
}

local plugin_specs = {

  {
    -- repo: https://github.com/p00f/clangd_extensions.nvim
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },

  {
    "nvim-cmp",
    opts = function(_, opts)
      local bufnr = vim.api.nvim_get_current_buf()
      local msg = string.format("nvim-cmp: Setting up completion for clangd_extensions on buffer %d", bufnr)
      vim.debug(msg, { title = "Completion - " .. title })
      -- table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
      table.insert(opts.sorting.comparators, 4, require("clangd_extensions.cmp_scores"))
      -- opts should either
      -- 1. return a table (overrides parent spec)
      -- 2. be a table (merged with parent spec)
      -- 3. alter a table (no return)
    end,
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      -- Ensure C/C++ debugger is installed
      "williamboman/mason.nvim",
    },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["codelldb"] then
        require("dap").adapters["codelldb"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "codelldb",
            args = {
              "--port",
              "${port}",
            },
          },
        }
      end
      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
          },
          {
            type = "codelldb",
            request = "attach",
            name = "Attach to process",
            pid = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },

  {
    "Civitasv/cmake-tools.nvim",
    lazy = true,
    init = function()
      local loaded = false
      local function check()
        local cwd = vim.uv.cwd()
        if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
          require("lazy").load({ plugins = { "cmake-tools.nvim" } })
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
    end,
    opts = {},
  },
}

return {
  clangd = clangd,
  plugin_specs = plugin_specs,
}
