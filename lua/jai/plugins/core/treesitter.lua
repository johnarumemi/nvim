-- [[ nvim-treesitter setup ]]
-- https://github.com/nvim-treesitter/nvim-treesitter

-- Treesitter Folding
-- https://vimhelp.org/usr_28.txt.html
-- https://alpha2phi.medium.com/neovim-for-beginners-code-folding-7574925412ea

local opt = vim.opt

opt.foldcolumn = "0"
opt.foldlevel = 20 -- set to a high level so that by default most folds are open
opt.foldmethod = "expr" -- allows for structured parsing to determine folds
opt.foldexpr = "nvim_treesitter#foldexpr()"

local treesitter_opts = {
  -- Below are mainly default settings
  -- A list of parser names, or "all" (the listed parsers should always be installed)
  ensure_installed = {
    "lua",
    "rust",
    "python",
    "markdown",
    "markdown_inline",
    "yaml",
    "toml",
        "cpp",
        "c",
    "javascript",
    "tsx",
    "typescript",
    "help",
    "go",
    "gitcommit",
    "gitignore",
    "git_rebase",
    "dockerfile",
    "jq",
    "json",
    "html",
    -- "norg", -- no parser available, managed by neorg plugin
    "terraform",
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,
  -- List of parsers to ignore installing (for "all")
  ignore_install = { "help" },
  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- nvim-treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim
return {
    {

  "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = {
      "TSInstall",
      "TSUpdate",
    },

  config = function()
    local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
    ts_update()
    require("nvim-treesitter.configs").setup(treesitter_opts)
  end,
  },
}
