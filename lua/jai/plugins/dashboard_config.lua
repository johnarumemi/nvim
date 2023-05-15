-- [[ dashboard startup screen config ]]

local opts = {
  theme = "hyper",
  config = {
    week_header = {
      enable = true,
    },
    shortcut = {
      {
        desc = " Update",
        group = "@property",
        action = "Lazy update",
        key = "u",
      },
      {
        desc = " Files",
        group = "Label",
        action = "Telescope find_files",
        key = "f",
      },
      -- TODO: the below 2 do not work, but serve as useful templates
      -- {
      --   desc = ' Apps',
      --   group = 'DiagnosticHint',
      --   action = 'Telescope app',
      --   key = 'a',
      -- },
      -- {
      --   desc = ' dotfiles',
      --   group = 'Number',
      --   action = 'Telescope dotfiles',
      --   key = 'd',
      -- },
    },
  },
}

return {
  opts = opts,
}
