-- repo (configuration): https://github.com/folke/noice.nvim?tab=readme-ov-file#%EF%B8%8F-configuration

local M = {}

M.opts = {

  cmdline = {
    enabled = true, -- enables the Noice cmdline UI
    view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
    opts = {}, -- global options for the cmdline. See section on views
    ---@type table<string, CmdlineFormat>
    format = {
      -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
      -- view: (default is cmdline view)
      -- opts: any options passed to the view
      -- icon_hl_group: optional hl_group for the icon
      -- title: set to anything or empty string to hide
      cmdline = { pattern = "^:", icon = "", lang = "vim" },
      search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
      filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
      lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
      help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
      input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
      -- lua = false, -- to disable a format, set to `false`
    },
  },
  messages = {
    -- NOTE: If you enable messages, then the cmdline is enabled automatically.
    -- This is a current Neovim limitation.
    enabled = true, -- enables the Noice messages UI
    view = "notify", -- default view for messages
    view_error = "mini", -- view for errors
    view_warn = "mini", -- view for warnings
    view_history = "messages", -- view for :messages
    view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
  },
  popupmenu = {
    enabled = true, -- enables the Noice popupmenu UI
    ---@type 'nui'|'cmp'
    backend = "nui", -- backend to use to show regular cmdline completions
    ---@type NoicePopupmenuItemKind|false
    -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
    kind_icons = {}, -- set to `false` to disable icons
  },
  -- default options for require('noice').redirect
  -- see the section on Command Redirection
  ---@type NoiceRouteConfig
  redirect = {
    view = "popup",
    filter = { event = "msg_show" },
  },
  -- You can add any custom commands below that will be available with `:Noice command`
  ---@type table<string, NoiceCommand>
  commands = {
    history = {
      -- options for the message history that you get with `:Noice`
      view = "split",
      opts = { enter = true, format = "details" },
      filter = {
        any = {
          { event = "notify" },
          { error = true },
          { warning = true },
          { event = "msg_show", kind = { "" } },
          { event = "lsp", kind = "message" },
        },
      },
      filter_opts = {},
    },
    -- :Noice last
    last = {
      view = "popup",
      opts = { enter = true, format = "details" },
      filter = {
        any = {
          { event = "notify" },
          { error = true },
          { warning = true },
          { event = "msg_show", kind = { "" } },
          { event = "lsp", kind = "message" },
        },
      },
      filter_opts = { count = 1 },
    },
    -- :Noice errors
    errors = {
      -- options for the message history that you get with `:Noice`
      view = "popup",
      opts = { enter = true, format = "details" },
      filter = { error = true },
      filter_opts = { reverse = true },
    },
    all = {
      -- options for the message history that you get with `:Noice`
      view = "split",
      opts = { enter = true, format = "details" },
      filter = {},
      filter_opts = {},
    },
  },
  notify = {
    -- Noice can be used as `vim.notify` so you can route any notification like other messages
    -- Notification messages have their level and other properties set.
    -- event is always "notify" and kind can be any log level as a string
    -- The default routes will forward notifications to nvim-notify
    -- Benefit of using Noice for this is the routing and consistent history view
    enabled = true,
    view = "notify",
  },
  lsp = {
    progress = {
      enabled = true,
      -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
      -- See the section on formatting for more details on how to customize.
      --- @type NoiceFormat|string
      format = "lsp_progress",
      --- @type NoiceFormat|string
      format_done = "lsp_progress_done",
      throttle = 1000 / 30, -- frequency to update lsp progress message
      view = "mini",
    },

    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      -- override the default lsp markdown formatter with Noice
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      -- override the lsp markdown formatter with Noice
      ["vim.lsp.util.stylize_markdown"] = true,
      -- override cmp documentation with Noice (needs the other options to work)
      -- requires hrsh7th/nvim-cmp
      ["cmp.entry.get_documentation"] = true,
    },
    hover = {
      enabled = true,
      silent = false, -- set to true to not show a message if hover is not available
      view = nil, -- when nil, use defaults from documentation
      ---@type NoiceViewOptions
      opts = {}, -- merged with defaults from documentation
    },
    signature = {
      enabled = true,
      auto_open = {
        enabled = true,
        trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
        luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
        throttle = 50, -- Debounce lsp signature help request by 50ms
      },
      view = nil, -- when nil, use defaults from documentation
      ---@type NoiceViewOptions
      opts = {}, -- merged with defaults from documentation
    },
    message = {
      -- Messages shown by lsp servers
      enabled = true,
      view = "notify",
      opts = {},
    },
    -- defaults for hover and signature help
    documentation = {
      view = "hover",
      ---@type NoiceViewOptions
      opts = {
        lang = "markdown",
        replace = true,
        render = "plain",
        format = { "{message}" },
        win_options = { concealcursor = "n", conceallevel = 3 },
      },
    },
  },
  markdown = {
    hover = {
      ["|(%S-)|"] = vim.cmd.help, -- vim help links
      ["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
    },
    highlights = {
      ["|%S-|"] = "@text.reference",
      ["@%S+"] = "@parameter",
      ["^%s*(Parameters:)"] = "@text.title",
      ["^%s*(Return:)"] = "@text.title",
      ["^%s*(See also:)"] = "@text.title",
      ["{%S-}"] = "@parameter",
    },
  },
  health = {
    checker = true, -- Disable if you don't want health checks to run
  },
  ---@type NoicePresets
  presets = {
    -- you can enable a preset by setting it to true, or a table that will override the preset config
    -- you can also add custom presets that you can enable/disable with enabled=true
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
  throttle = 1000 / 30, -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
  ---@type NoiceConfigViews
  views = {
    popupmenu = {
      relative = "editor",
      zindex = 65,
      position = "auto", -- when auto, then it will be positioned to the cmdline or cursor
      size = {
        width = "auto",
        height = "auto",
        max_height = 20,
        -- min_width = 10,
      },
      win_options = {
        winbar = "",
        foldenable = false,
        cursorline = true,
        cursorlineopt = "line",
        winhighlight = {
          Normal = "NoicePopupmenu", -- change to NormalFloat to make it look like other floats
          FloatBorder = "NoicePopupmenuBorder", -- border highlight
          CursorLine = "NoicePopupmenuSelected", -- used for highlighting the selected item
          PmenuMatch = "NoicePopupmenuMatch", -- used to highlight the part of the item that matches the input
        },
      },
      border = {
        padding = { 0, 1 },
      },
    },
    cmdline_popupmenu = {
      view = "popupmenu",
      zindex = 200,
    },
    snacks = {
      backend = "snacks",
      fallback = "nvim_notify",
      format = "notify",
      replace = false,
      merge = false,
    },
  }, ---@see section on views
  ---@type NoiceRouteConfig[]
  routes = {

    { -- hide messages with following strings in them completely

      filter = {
        event = "msg_show",
        kind = "",
        ["any"] = {
          { find = "written" },
          { find = "change; before" },
          { find = "change; after" },
        },
      },
      opts = { skip = true },
    },
    { -- taken from LazyVim
      -- link: https://github.com/LazyVim/LazyVim/blob/cb40a09538dc0c417a7ffbbacdbdec90be4a792c/lua/lazyvim/plugins/ui.lua#L278C8-L288
      filter = {
        event = "msg_show",
        any = {
          { find = "%d+L, %d+B" },
          { find = "; after #%d+" },
          { find = "; before #%d+" },
          { find = "yanked" },
        },
      },
      view = "mini",
    },

    {
      -- move messages with below string in them to `mini` view
      filter = {
        event = "msg_show",
        kind = "",
        ["any"] = {
          { find = "fewer lines" },
          { find = "more lines" },
          { find = "line less" },
          { find = "Already at newest" },
          { find = "Already at oldest" },
        },
      },
      view = "mini",
    },

    {
      -- move messages with below string in them to `mini` view
      filter = {
        event = "msg_show",
        kind = "",
        find = 'Change "%a+" to:',
      },
      view = "cmdline_popupmenu",
      -- opts = {
      --   backend = "nui.menu",
      -- },
    },

    -- reroute all notify messages to the split view
    -- {
    --   filter = {
    --     event = "notify",
    --     kind = { "debug" },
    --     blocking = false,
    --   },
    --   view = "messages",
    --   opts = { stop = true },
    -- },

    -- { -- route long messages to split
    --   filter = {
    --     event = "msg_show",
    --     any = { { min_height = 5 }, { min_width = 200 } },
    --     ["not"] = {
    --       kind = { "confirm", "confirm_sub", "return_prompt", "quickfix", "search_count" },
    --     },
    --     blocking = false,
    --   },
    --   view = "messages",
    --   opts = { stop = true },
    -- },
    -- { -- route long messages to split
    --   filter = {
    --     event = "msg_show",
    --     any = { { min_height = 5 }, { min_width = 200 } },
    --     ["not"] = {
    --       kind = { "confirm", "confirm_sub", "return_prompt", "quickfix", "search_count" },
    --     },
    --     blocking = true,
    --   },
    --   view = "mini",
    -- },
  }, --- @see section on routes
  ---@type table<string, NoiceFilter>
  status = {}, --- @see section on statusline components
  ---@type NoiceFormatOptions
  format = {}, --- @see section on formatting
}

return M
