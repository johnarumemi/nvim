-- [[ rust-tools configuration ]]
-- https://github.com/simrat39/rust-tools.nvim

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
-- TODO: can this be scoped to a buffer specific option?
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

local rt = require("rust-tools")

local default_on_attach = require("jai.lsp.on_attach")
local capabilities = require("jai.lsp.capabilities")


-- custom on_attach for rust LSP
local function on_attach(client, bufnr)
    -- apply default key mappings first

    default_on_attach(client, bufnr)

      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })

      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
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
    capabilities=capabilities,
    on_attach = on_attach,
    settings = {
        -- Server-specific settings for rust-analyzer LSP
        ['rust-analyzer'] = {
            -- enable clippy on save
            checkOnSave = {
                command = 'clippy',
            }
        }
    }
  },
}

rt.setup(opts)

