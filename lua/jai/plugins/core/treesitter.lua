-- [[ nvim-treesitter setup ]]
-- https://github.com/nvim-treesitter/nvim-treesitter

-- Treesitter Folding
-- https://vimhelp.org/usr_28.txt.html
-- https://alpha2phi.medium.com/neovim-for-beginners-code-folding-7574925412ea

local opt = vim.opt

-- Only set these options in standalone Neovim, not VS Code
if not vim.g.vscode then
  opt.foldcolumn = "0"
  opt.foldlevel = 20 -- set to a high level so that by default most folds are open
  opt.foldmethod = "expr" -- allows for structured parsing to determine folds
  opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
end

local parsers = {
  "asm", -- Assembly
  "bash",
  "c",
  "comment",
  "cpp",
  "cmake",
  "diff", -- .diff files
  "disassembly", -- repo: https://github.com/ColinKennedy/tree-sitter-disassembly
  "dockerfile",
  "gitattributes",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "gowork",
  "html",
  "javascript",
  "json",
  "jq",
  "just",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "nasm",
  "objdump", -- repo: https://github.com/ColinKennedy/tree-sitter-objdump
  "proto", -- Protocol Buffers
  "python",
  "regex",
  "ron", -- Rusty Object Notation
  "rust",
  "ssh_config", -- ssh config files
  "solidity",
  "sql",
  "terraform",
  "tmux",
  "toml",
  "tsx",
  "typescript",
  "vimdoc",
  "yaml",
}

-- nvim-treesitter (main branch - new API)
-- https://github.com/nvim-treesitter/nvim-treesitter
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Disable in VS Code as it has its own syntax highlighting
    enabled = function()
      return not vim.g.vscode
    end,
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      -- Install desired parsers
      require("nvim-treesitter").install(parsers)

      -- Enable treesitter highlighting, with large-file guard
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
          if ok and stats and stats.size > max_filesize then
            return
          end
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
