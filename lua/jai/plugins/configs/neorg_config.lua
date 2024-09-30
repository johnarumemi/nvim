local wk = require("which-key")

local default_workspace = nil
local base_dir = os.getenv("HOME") .. "/neorg-notes/"

vim.debug("Neorg base workspace directory is " .. base_dir, { title = "Neorg" })

-- NOTE: when using the `<locallleader>n` keymap to create a
-- new notes, this will be created within your currently set
-- default workspace. Hence why this is scoped to different
-- sections to ensure work and personal notes are not
-- grouped together.
if _G.neorg_env == "WORK" then
  default_workspace = "notes-work"
elseif _G.neorg_env == "HOME" then
  default_workspace = "notes-private"
else
  default_workspace = "notes-private"
end

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
          ["notes-private"] = base_dir .. "notes/private",
          ["notes-work"] = base_dir .. "notes/work",
          ["todo-work"] = base_dir .. "todo/work",
          ["todo-private"] = base_dir .. "todo/private",
          rust = base_dir .. "rust",
          ["computer-architecture"] = base_dir .. "computer-architecture",
          ["arm"] = base_dir .. "arm",
        },
        default_workspace = default_workspace,
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

    -- update options for current buffer only
    -- num:  Size of an indent
    vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
    --  num:  Number of spaces tabs count for in insert mode
    vim.api.nvim_buf_set_option(0, "softtabstop", 2)
    -- num:  Number of spaces tabs count for
    vim.api.nvim_buf_set_option(0, "tabstop", 2)

    wk.add({
      -- { "<leader>nl", "[[:Neorg keybind all core.looking-glass.magnify-code-block<CR>]]", buffer = buf, desc = "Looking Glass" },
      { "<leader>N", group = "Neorg" },
      { "<leader>Nt", ":Neorg toc<CR>", buffer = buf, desc = "Open Table of Contents" },
      { "<leader>Nc", ":Neorg context toggle<CR>", buffer = buf, desc = "Toggle Neorg Context" },
      { "<leader>tc", ":Neorg toggle-concealer<CR>", buffer = buf, desc = "Toggle Neorg Concealer" },
    })

    wk.add({
      { "<localleader>tt", "<Plug>(neorg.qol.todo-items.todo.task-cycle)", desc = "Cycle State" },
      -- related to core.qol.todo_items
      -- <Plug>(neorg.qol.todo-items.todo.task-done) (<LocalLeader>td)
      -- <Plug>(neorg.qol.todo-items.todo.task-undone) (<LocalLeader>tu)
      -- <Plug>(neorg.qol.todo-items.todo.task-pending) (<LocalLeader>tp)
      -- <Plug>(neorg.qol.todo-items.todo.task-on_hold) (<LocalLeader>th)
      -- <Plug>(neorg.qol.todo-items.todo.task-cancelled) (<LocalLeader>tc)
      -- <Plug>(neorg.qol.todo-items.todo.task-recurring) (<LocalLeader>tr)
      -- <Plug>(neorg.qol.todo-items.todo.task-important) (<LocalLeader>ti)
      -- <Plug>(neorg.qol.todo-items.todo.task-cycle) (<C-Space>) & <LocalLeader>tt
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
