-- [[ rust-tools configuration ]]
-- https://github.com/simrat39/rust-tools.nvim

local rt = require("rust-tools")

local function create_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- for cpm_nvim_lsp
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end

-- custom on_attach for rust LSP
local function core_on_attach(client, bufnr)
  -- apply default on_attach first
  require("jai.plugins.core.lsp.on_attach").on_attach(client, bufnr)

  -- Hover actions
  vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })

  -- Code action groups
  vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })

  -- Set completeopt to have a better completion experience
  -- :help completeopt
  -- menuone: popup even when there's only one match
  -- noinsert: Do not insert text until a selection is made
  -- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
  vim.api.nvim_set_option_value("completeopt", "menuone,noinsert,noselect", { buf = bufnr })

  -- -- Avoid showing extra messages when using completion
  local current_shortmess = vim.api.nvim_get_option_value("shortmess", { buf = bufnr })
  vim.api.nvim_set_option_value("shortmess", current_shortmess + "c", { buf = bufnr })
  -- vim.opt.shortmess = vim.opt.shortmess + "c"
end

-- rust-tools options
local opts = {
  tools = {
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = true,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },
  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
  server = {
    capabilities = create_capabilities(),
    on_attach = function(client, bufnr)
      core_on_attach(client, bufnr)
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      -- TODO: should this be shifted to whichkey?
      vim.keymap.set("n", "<leader>rr", [[:RustRunnables<CR>]], bufopts)
    end,
    settings = {
      -- Server-specific settings for rust-analyzer LSP
      ["rust-analyzer"] = {
        procMacros = {
          enable = true,
        },
        cargo = {
          allFeatures = true,
        },
        -- enable clippy on save
        checkOnSave = {
          command = "clippy",
          -- To prevent check on save taking a lock on the target dir (blocking cargo build/run)
          extraArgs = { "--target-dir", "target/ra-check" },
        },
      },
    },
  },
}

return {

  opts = opts,
}
