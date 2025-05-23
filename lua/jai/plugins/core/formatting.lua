vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

return {
  -- repo: https://github.com/stevearc/conform.nvim
  "stevearc/conform.nvim",
  -- Disable formatting in VS Code as it has its own formatting capabilities
  enabled = function()
    return not vim.g.vscode
  end,
  version = "^8.0.0",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      -- Keymap for triggering formating via conform
      "<space>f",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format Buffer",
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = vim.tbl_deep_extend("error", {
      -- enable on mac and linux
      lua = { "stylua" },
      yaml = { "yamlfmt" },
      -- python = { "isort", "black" },
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    }, JUtil.os.is_mac() and {
      -- mac only
      asm = { "asmfmt" },
      sql = { "sql_formatter" },
    } or {
      -- linux only
    }),
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- Set up format-on-save
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
  },
  -- init = function()
  --   -- If you want the formatexpr, here is the place to set it
  --   vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  -- end,
}
