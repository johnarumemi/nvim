# Resize Windows

This can be used to resize the buffer with id `<number>`,
or `0` for current buffer.

```bash
:echo winwidth(<number>)
:echo winheight(<number>)

# for example
:echo winwidth(0)
:echo winheight(0)
```

```vim
:lua print(vim.api.nvim_win_get_width(<number>))
```

# No Wrap

`:set nowrap` only prevents it from wrapping the display
of lines, not from inserting linebreaks.

Use `set formatoptions-=t` to actually stop wrapping of
lines completely.

# Create autocommands

```lua
vim.api.nvim_create_autocmd({ events }, {
  -- find current windows filetype via using `:echo &ft`
  pattern = { "*.norg" },
  -- command = "set conceallevel=3",
  desc = "Setup Neorg configuration",
  callback = function(id, event, group, match, buf, file, data)
    -- find current values via `:set nowrap?`
  end,
})
```

**Note**: _pattern_: find via `:echo &ft`
