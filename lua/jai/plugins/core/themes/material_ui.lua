-- [[ Configuring Material UI ]]
-- https://github.com/marko-cerovac/material.nvim

local M = {}

-- set style to one of:
-- 1. darker
-- 2. lighter
-- 3. oceanic (default)
-- 4. palenight
-- 5. deep ocean
M.material_style = "deep ocean"

M.opts = {
  contrast = {
    terminal = true, -- Enable contrast for the built-in terminal
    sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
    floating_windows = true, -- Enable contrast for floating windows
    cursor_line = true, -- Enable darker background for the cursor line
    non_current_windows = false, -- Enable darker background for non-current windows
    filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
  },
  styles = { -- Give comments style such as bold, italic, underline etc.
    comments = { --[[ italic = true ]]
    },
    strings = { --[[ bold = true ]]
    },
    keywords = { --[[ underline = true ]]
    },
    functions = { --[[ bold = true, undercurl = true ]]
    },
    variables = {},
    operators = {},
    types = {},
  },
  plugins = { -- Uncomment the plugins that you use to highlight them
    -- Available plugins:
    "dap",
    -- "dashboard",
    -- "gitsigns",
    -- "hop",
    -- "indent-blankline",
    -- "lspsaga",
    -- "mini",
    -- "neogit",
    "nvim-cmp",
    -- "nvim-navic",
    "nvim-tree",
    "nvim-web-devicons",
    -- "sneak",
    "telescope",
    -- "trouble",
    -- "which-key",
  },
  disable = {
    colored_cursor = false, -- Disable the colored cursor
    borders = false, -- Disable borders between verticaly split windows
    background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
    term_colors = false, -- Prevent the theme from setting terminal colors
    eob_lines = false, -- Hide the end-of-buffer lines
  },
  high_visibility = {
    lighter = false, -- Enable higher contrast text for lighter style
    darker = true, -- Enable higher contrast text for darker style
  },
  lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )
  async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)
  custom_colors = nil, -- If you want to everride the default colors, set this to a function
  custom_highlights = {}, -- Overwrite highlights with your own
}

return M

-- According to github documentation, we must issue the command
-- to set the theme AFTER we have executed the setup function above.
-- You won't see your settings applied on startup of the theme otherwise.
-- All you will see is the default oceanic theme.
-- vim.cmd("colorscheme material") -- cmd:  Set colorscheme to use dracula plugin
