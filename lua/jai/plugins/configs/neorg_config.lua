-- my custom augroups
local function jai_augroup(name)
  return vim.api.nvim_create_augroup("jai_" .. name, { clear = true })
end

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
    ["core.esupports.metagen"] = {
      config = {
        author = "john",

        -- WARNING: Causing plugins to fail on nightly
        -- issue: https://github.com/nvim-neorg/neorg/issues/1579
        update_date = false,
      },
    },
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
          list = {
            icons = { "❖", "♦" },
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

vim.g.conceal_set = {}

-- Some options do not work on the `BufNew` event.
-- These are applied here instead.
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = jai_augroup("neorg_setup_conceallevel"),
  pattern = { "*.norg" },
  desc = "Setup Neorg conceal level",
  callback = function(args)
    local title = "Autocmd - Neorg - Setup Conceallevel"

    if args.buf == nil then
      vim.error(string.format("%s: failed setup as received a nill buffer", args.event), { title = title })
      return
    end

    -- Get shortlived copy
    local conceal_set = vim.g.conceal_set

    -- if it's nill, then conceal has not been set, so continue
    if conceal_set[args.buf] ~= nil then
      vim.warn(string.format("%s: conceallevel already set for buffer: %d", args.event, args.buf), { title = title })
      return
    end

    vim.api.nvim_buf_set_option(args.buf, "conceallevel", 3)
    vim.api.nvim_buf_set_option(args.buf, "spell", true)

    conceal_set[args.buf] = true

    -- update global variable via writing out the whole table
    vim.g.conceal_set = conceal_set

    -- check the updated global variable
    local set_value = vim.g.conceal_set[args.buf]

    if set_value == nil then
      vim.error(
        string.format("%s: failed to cache conceal_set (nil value returned) for buffer: %d", args.event, args.buf),
        { title = title }
      )
      return
    else
      local msg = string.format("%s: conceallevel applied for buffer: %d", args.event, args.buf)

      vim.debug(msg, { title = title })
    end
  end,
})

-- documenation: https://neovim.io/doc/user/api.html#nvim_create_autocmd()
-- Use BufNew to trigger on new buffers only. BufEnter triggers each time
-- we switched to a new or exisiting buffer.
vim.api.nvim_create_autocmd({ "BufNew" }, {
  group = jai_augroup("neorg_setup_config"),
  pattern = { "*.norg" },
  desc = "Setup Neorg configuration",

  -- param is a single table with following keys:
  -- id: (number) autocommand id
  -- event: (string) name of the triggered event autocmd-events
  -- group: (number|nil) autocommand group id, if any
  -- match: (string) expanded value of <amatch>
  -- buf: (number) expanded value of <abuf>
  -- file: (string) expanded value of <afile>
  -- data: (any) arbitrary data passed from nvim_exec_autocmds()
  callback = function(args)
    local title = "Autocmd - Neorg - Setup Config"

    if args.buf == nil then
      vim.error(string.format("%s: failed setup as received a nill buffer", args.event), { title = title })
      return
    end

    -- only applies when using Filetype and a pattern of { "norg" }
    if args.match ~= args.file then
      local fmatch_msg = string.format("%s: <amatch>=%s | <afile>=%s", args.event, args.match, args.file)
      vim.debug(fmatch_msg, { title = title })
    end

    -- only prevents it from wrapping the display of lines, not from inserting linebreaks.
    -- use `set formatoptions-=t` to actually stop wrapping of lines completely
    vim.api.nvim_buf_set_option(args.buf, "wrap", false)
    vim.api.nvim_buf_set_option(args.buf, "textwidth", 75)

    -- update options for current buffer only
    --
    -- num:  Size of an indent
    vim.api.nvim_buf_set_option(args.buf, "shiftwidth", 2)
    --  num:  Number of spaces tabs count for in insert mode
    vim.api.nvim_buf_set_option(args.buf, "softtabstop", 2)
    -- num:  Number of spaces tabs count for
    vim.api.nvim_buf_set_option(args.buf, "tabstop", 2)

    wk.add({
      -- { "<leader>nl", "[[:Neorg keybind all core.looking-glass.magnify-code-block<CR>]]", buffer = buf, desc = "Looking Glass" },
      { "<leader>N", group = "Neorg" },
      { "<leader>Nt", ":Neorg toc<CR>", buffer = args.buf, desc = "Open Table of Contents" },
      { "<leader>Nc", ":Neorg context toggle<CR>", buffer = args.buf, desc = "Toggle Neorg Context" },
      { "<leader>tc", ":Neorg toggle-concealer<CR>", buffer = args.buf, desc = "Toggle Neorg Concealer" },
    })

    wk.add({
      { "<localleader>t", group = "Todo", buffer = args.buf },
      { "<localleader>tt", "<Plug>(neorg.qol.todo-items.todo.task-cycle)", buffer = args.buf, desc = "Cycle State" },
      { "<localleader>oc", ":Neorg toc left<CR>", buffer = args.buf, desc = "Open Table of Contents" },
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

    local msg = string.format("%s: settings applied for buffer: %d", args.event, args.buf)

    vim.debug(msg, { title = title })
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
