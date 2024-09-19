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
        icon_preset = "diamond",
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
          ["todo-work"] = "~/neorg-notes/todo/work",
          ["todo-private"] = "~/neorg-notes/todo/private",
          rust = "~/neorg-notes/rust",
          ["computer-architecture"] = "~/neorg-notes/computer-architecture",
        },
        default_workspace = "notes",
      },
    },
    ["core.presenter"] = {
      config = {
        zen_mode = "zen-mode",
      },
    },
    -- repo: https://github.com/nvim-neorg/neorg/wiki/Todo-Items
    ["core.qol.todo_items"] = {},

    -- repo: https://github.com/nvim-neorg/neorg/wiki/Todo-Introspector#counted_statuses
    ["core.todo-introspector"] = {},
    -- repo:https://github.com/nvim-neorg/neorg/wiki/Itero
    -- keymap: <Option + enter> mode = insert
    ["core.itero"] = {},
    ["core.pivot"] = {},

    -- repo: https://github.com/nvim-neorg/neorg/wiki/Looking-Glass
    ["core.looking-glass"] = {},

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

      { "<localleader>tt", "<Plug>(neorg.qol.todo-items.todo.task-cycle)", desc = "Cycle State" },
    })
    wk.add({
      -- { "<leader>nl", "[[:Neorg keybind all core.looking-glass.magnify-code-block<CR>]]", buffer = buf, desc = "Looking Glass" },
      { "<leader>N", group = "Neorg" },
      { "<leader>Nt", ":Neorg toc<CR>", buffer = buf, desc = "Open Table of Contents" },
      { "<leader>Nc", ":Neorg context toggle<CR>", buffer = buf, desc = "Toggle Neorg Context" },
      {
        { "<leader>Nw", group = "Workspaces" },
        { "<leader>Nww", ":Neorg workspace todo-work<CR>", buffer = buf, desc = "Open Todo - Work" },
        { "<leader>Nwp", ":Neorg workspace todo-private<CR>", buffer = buf, desc = "Open Todo - Private" },
        { "<leader>Nwr", ":Neorg workspace rust<CR>", buffer = buf, desc = "Open Rust " },
      },

      { "<leader>tc", ":Neorg toggle-concealer<CR>", buffer = buf, desc = "Toggle Neorg Concealer" },
      -- related to core.qol.todo_items
      -- <Plug>(neorg.qol.todo-items.todo.task-done) (<LocalLeader>td)
      -- <Plug>(neorg.qol.todo-items.todo.task-undone) (<LocalLeader>tu)
      -- <Plug>(neorg.qol.todo-items.todo.task-pending) (<LocalLeader>tp)
      -- <Plug>(neorg.qol.todo-items.todo.task-on_hold) (<LocalLeader>th)
      -- <Plug>(neorg.qol.todo-items.todo.task-cancelled) (<LocalLeader>tc)
      -- <Plug>(neorg.qol.todo-items.todo.task-recurring) (<LocalLeader>tr)
      -- <Plug>(neorg.qol.todo-items.todo.task-important) (<LocalLeader>ti)
      -- <Plug>(neorg.qol.todo-items.todo.task-cycle) (<C-Space>)
      -- <Plug>(neorg.qol.todo-items.todo.task-cycle-reverse)
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
