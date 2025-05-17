-- [[ Markdown Preview ]]
-- repo: https://github.com/iamcco/markdown-preview.nvim
-- I am mainly installing this for use with Mermaid.js or PlantUML

local wk = require("which-key")

local function jai_augroup(name)
  return vim.api.nvim_create_augroup("jai_" .. name, { clear = true })
end

local which_key_group = "Markdown Preview"

vim.notify("Markdown Preview: loading config", vim.log.levels.INFO, { title = "Markdown Preview" })
-- documenation: https://neovim.io/doc/user/api.html#nvim_create_autocmd()
-- Use BufNew to trigger on new buffers only. BufEnter triggers each time
-- we switched to a new or exisiting buffer.
vim.api.nvim_create_autocmd({ "BufNew" }, {
  group = jai_augroup("markdown_preview_setup_config"),
  pattern = { "*.markdown" },
  desc = "Setup Markdown configuration",

  -- args is a single table with following keys:
  -- id: (number) autocommand id
  -- event: (string) name of the triggered event autocmd-events
  -- group: (number|nil) autocommand group id, if any
  -- match: (string) expanded value of <amatch>
  -- buf: (number) expanded value of <abuf>
  -- file: (string) expanded value of <afile>
  -- data: (any) arbitrary data passed from nvim_exec_autocmds()
  callback = function(args)
    local title = "Autocmd - Markdown - Setup Config"

    if args.buf == nil then
      vim.error(string.format("%s: failed setup as received a nill buffer", args.event), { title = title })
      return
    else
      vim.debug("Starting markdown previous setup for buffer: " .. args.buf, { title = title })
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
      { "<leader>m", group = which_key_group },
      { "<leader>mo", "[[:MarkdownPreview<CR>]]", buffer = args.buf, desc = "Open" },
      { "<leader>ms", "[[:MarkdownPreviewStop<CR>]]", buffer = args.buf, desc = "Stop" },
      { "<leader>tm", "[[:MarkdownPreviewToggle<CR>]]", buffer = args.buf, desc = "Markdown Preview Toggle" },
    })

    local msg = string.format("%s: settings applied for buffer: %d", args.event, args.buf)

    vim.debug(msg, { title = title })
  end,
})

-- set to 1, nvim will open the preview window after entering the markdown buffer
-- default: 0
vim.g.mkdp_auto_start = 0

-- set to 1, the nvim will auto close current preview window when change
-- from markdown buffer to another buffer
-- default: 1
vim.g.mkdp_auto_close = 1

-- set to 1, the vim will refresh markdown when save the buffer or
-- leave from insert mode, default 0 is auto refresh markdown as you edit or
-- move the cursor
-- default: 0
vim.g.mkdp_refresh_slow = 0

-- set to 1, the MarkdownPreview command can be use for all files,
-- by default it can be use in markdown file
-- default: 0
vim.g.mkdp_command_for_global = 0

-- set to 1, preview server available to others in your network
-- by default, the server listens on localhost (127.0.0.1)
-- default: 0
vim.g.mkdp_open_to_the_world = 0

-- use custom IP to open preview page
-- useful when you work in remote vim and preview on local browser
-- more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
-- default empty
vim.g.mkdp_open_ip = ""

-- specify browser to open preview page
-- for path with space
-- valid: `/path/with\ space/xxx`
-- invalid: `/path/with\\ space/xxx`
-- default: ''
vim.g.mkdp_browser = ""

-- set to 1, echo preview page url in command line when open preview page
-- default is 0
vim.g.mkdp_echo_preview_url = 0

-- a custom vim function name to open preview page
-- this function will receive url as param
-- default is empty
vim.g.mkdp_browserfunc = ""

-- options for markdown render
-- mkit: markdown-it options for render
-- katex: katex options for math
-- uml: markdown-it-plantuml options
-- maid: mermaid options
-- disable_sync_scroll: if disable sync scroll, default 0
-- sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
--   middle: mean the cursor position alway show at the middle of the preview page
--   top: mean the vim top viewport alway show at the top of the preview page
--   relative: mean the cursor position alway show at the relative positon of the preview page
-- hide_yaml_meta: if hide yaml metadata, default is 1
-- sequence_diagrams: js-sequence-diagrams options
-- content_editable: if enable content editable for preview page, default: v:false
-- disable_filename: if disable filename header for preview page, default: 0
-- vim.g.mkdp_preview_options = {
--      'mkit': {},
--      'katex': {},
--      'uml': {},
--      'maid': {},
--      'disable_sync_scroll': 0,
--      'sync_scroll_type': 'middle',
--      'hide_yaml_meta': 1,
--      'sequence_diagrams': {},
--      'flowchart_diagrams': {},
--      'content_editable': v:false,
--      'disable_filename': 0,
--      'toc': {}
--      }

-- use a custom markdown style must be absolute path
-- like '/Users/username/markdown.css' or expand('~/markdown.css')
vim.g.mkdp_markdown_css = ""

-- use a custom highlight style must absolute path
-- like '/Users/username/highlight.css' or expand('~/highlight.css')
vim.g.mkdp_highlight_css = ""

-- use a custom port to start server or empty for random
vim.g.mkdp_port = ""

-- preview page title
-- ${name} will be replace with the file name
vim.g.mkdp_page_title = "「${name}」"

-- recognized filetypes
-- these filetypes will have MarkdownPreview... commands
vim.g.mkdp_filetypes = { "markdown" }

-- set default theme (dark or light)
-- By default the theme is define according to the preferences of the system
vim.g.mkdp_theme = "dark"
