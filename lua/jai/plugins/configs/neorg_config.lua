local wk = require("which-key")

local opts = {
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.export"] = {}, -- enable export module
    ["core.export.markdown"] = {
      config = {
        extensions = "all",
      },
    },
    ["core.completion"] = { -- interface with different completion engines
      config = {
        engine = "nvim-cmp",
      },
    },
    ["core.summary"] = {}, -- Creates links to all files in any workspace
    ["core.concealer"] = {
      config = {
        -- basic, diamond or varied
        icon_preset = "basic",
        icons = {
          code_block = {
            conceal = true,
            width = "content",
            padding = {
              right = 10,
            },
          },
        },
      },
    }, -- Adds pretty icons to your documents
    ["core.dirman"] = { -- Manages Neorg workspaces
      config = {
        workspaces = {
          notes = "~/neorg-notes/notes",
          rust = "~/neorg-notes/rust",
          cs = "~/neorg-notes/cs",
        },
        default_workspace = "notes",
      },
    },
    ["core.presenter"] = {
      config = {
        zen_mode = "zen-mode",
      },
    },

    -- neorg-conceal-wrap module
    -- repo: https://github.com/benlubas/neorg-conceal-wrap
    ["external.conceal-wrap"] = {},

    -- Neorg-Contexts module
    -- repo: https://github.com/max397574/neorg-contexts
    ["external.context"] = {},
  },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.norg" },
  -- command = "set conceallevel=3",
  desc = "Setup Neorg configuration",
  callback = function(id, event, group, match, buf, file, data)
    vim.cmd("set conceallevel=3")
    vim.cmd("set nowrap")
    vim.cmd("set textwidth=60")
    -- vim.cmd("colorscheme terafox")

    -- update options for current buffer only
    -- num:  Size of an indent
    vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
    --  num:  Number of spaces tabs count for in insert mode
    vim.api.nvim_buf_set_option(0, "softtabstop", 2)
    -- num:  Number of spaces tabs count for
    vim.api.nvim_buf_set_option(0, "tabstop", 2)

    wk.add({
      -- { "<leader>nl", "[[:Neorg keybind all core.looking-glass.magnify-code-block<CR>]]", buffer = buf, desc = "Looking Glass" },
      { "<leader>tc", ":Neorg toggle-concealer<CR>", buffer = buf, desc = "Toggle Neorg Concealer" },
    })
  end,
})

-- Use internal formatting for bindings like gq.
vim.api.nvim_create_autocmd("LspAttach", {
  pattern = { "*.norg" },
  callback = function(args)
    vim.bo[args.buf].formatexpr = nil
  end,
})

return {
  opts = opts,
}
