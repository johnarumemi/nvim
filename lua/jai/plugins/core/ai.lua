local prompts = {
  -- Code related prompts
  BetterNamings = "Provide better names for the following variables, functions, types and modules.",
  Documentation = "Provide documentation for the following code.",
  Explain = {
    prompt = "Explain how the following code works.",
  },
  FixCode = "Fix the following code to make it work as intended.",
  FixError = "Explain the error in the following text and provide a solution.",
  Refactor = "Refactor the following code to improve its clarity and readability.",
  Review = "Review the following code and provide suggestions for improvement.",
  SwaggerApiDocs = "Provide documentation for the following API using Swagger.",
  SwaggerJsDocs = "Write JSDoc for the following API using Swagger.",
  Tests = "Explain how the selected code works, then generate unit tests for it.",
  -- Text related prompts
  Concise = "Rewrite the following text to make it more concise.",
  Spelling = "Correct any grammar and spelling errors in the following text.",
  Summarize = "Summarize the following text.",
  Wording = "Improve the grammar and wording of the following text.",
}

return {

  {
    -- repo: https://github.com/zbirenbaum/copilot.lua
    "zbirenbaum/copilot.lua",
    -- Disable Copilot in VS Code as it has its own Copilot extension
    enabled = function()
      return not vim.g.vscode
    end,
    cmd = { "Copilot" },
    event = { "InsertEnter" },
    config = function()
      require("copilot").setup({

        -- suggested for using copilot-cmp as they can interfer with
        -- completions properly appearing in copilot-cmp
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    -- repo: https://github.com/zbirenbaum/copilot-cmp
    --
    -- turn `zbirenbaum/copilot.lu` into a completion source, rather than have
    -- it pollute your inline text insertions.
    --
    -- Note: part of configuring this involves adding it as a source to nvim-cmp.
    -- So if uninstalling, ensure that is removed aswell.
    "zbirenbaum/copilot-cmp",
    -- Disable Copilot CMP in VS Code
    enabled = function()
      return not vim.g.vscode
    end,
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    -- repo: https://github.com/AndreM222/copilot-lualine
    --
    -- add copilot status sign in lualine
    "AndreM222/copilot-lualine",
    -- Disable Copilot lualine in VS Code as it's not needed
    enabled = function()
      return not vim.g.vscode
    end,
  },
  {
    -- repo: https://github.com/CopilotC-Nvim/CopilotChat.nvim
    --
    "CopilotC-Nvim/CopilotChat.nvim",
    -- Disable CopilotChat in VS Code as it has its own Copilot Chat
    enabled = function()
      return not vim.g.vscode
    end,
    -- Do not use branch and version together, either use branch or version
    version = "v3.9",
    -- branch = "main",
    -- branch = "canary", -- Use the canary branch if you want to test the latest features but it might be unstable
    event = "VeryLazy",
    dependencies = {
      { "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      -- debug = true, -- Enable debugging

      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
      prompts = prompts,
      model = "claude-3.7-sonnet",
      auto_follow_cursor = false, -- Don't follow the cursor after getting response
      show_help = false, -- Show help in virtual text, set to true if that's 1st time using Copilot Chat
      mappings = {
        -- Use tab for completion
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          insert = "<Tab>",
        },
        -- Close the chat
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        -- Reset the chat buffer
        reset = {
          normal = "<C-x>",
          insert = "<C-x>",
        },
        -- Submit the prompt to Copilot
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-CR>",
        },
        -- Accept the diff
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
        -- Yank the diff in the response to register
        yank_diff = {
          normal = "gmy",
        },
        -- Show the diff
        show_diff = {
          normal = "gmd",
        },
        -- Show the prompt
        show_system_prompt = {
          normal = "gmp",
        },
        -- Show the user selection
        show_user_selection = {
          normal = "gms",
        },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")
      local context = require("CopilotChat.context")
      -- Use unnamed register for the selection
      opts.selection = select.unnamed

      -- Override / Extend the git prompts message
      opts.prompts.Commit = {
        prompt = "Write commit message for all changes with commitizen convention",
        selection = function()
          return vim.fn.system("git diff")
        end,
      }
      opts.prompts.CommitStaged = {
        prompt = "Write commit message for staged changes with commitizen convention",
        selection = function()
          return vim.fn.system("git diff --staged")
        end,
      }
      opts.prompts.SortByKeys = {
        description = "Sort by keys alphabetically.",
        prompt = "Please sort the following by keys alphabetically, in ascending order.",
        selection = select.visual,
      }

      chat.setup(opts)

      -- DEPRECATED: Not working after moving from v2 to v3
      -- Setup the CMP integration
      -- require("CopilotChat.integrations.cmp").setup()

      vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = "*", range = true })

      -- Inline chat with Copilot
      vim.api.nvim_create_user_command("CopilotChatInline", function(args)
        chat.ask(args.args, {
          selection = select.visual,
          window = {
            layout = "float",
            relative = "cursor",
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end, { nargs = "*", range = true })

      -- Restore CopilotChatBuffer
      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = "*", range = true })

      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = true

          -- Get current filetype and set it to markdown if the current filetype is copilot-chat
          local ft = vim.bo.filetype
          if ft == "copilot-chat" then
            vim.bo.filetype = "markdown"
          end
        end,
      })

      -- Setup which-key mappings
      local wk = require("which-key")

      wk.add({
        { "<leader>a", group = "Copilot Chat" },
        -- Show help actions with telescope
        {
          "<leader>ah",
          function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.help_actions())
          end,
          desc = "CopilotChat - Help actions",
        },
        -- Show prompts actions with telescope
        {
          "<leader>ap",
          function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
          end,
          desc = "CopilotChat - Prompt actions",
        },
        {
          "<leader>ap",
          ":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
          mode = "x",
          desc = "CopilotChat - Prompt actions",
        },
        -- Code related commands
        { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
        { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
        { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
        { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
        { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
        -- Chat with Copilot in visual mode
        {
          "<leader>av",
          ":CopilotChatVisual",
          mode = "x",
          desc = "CopilotChat - Open in vertical split",
        },
        {
          "<leader>ax",
          ":CopilotChatInline<cr>",
          mode = "x",
          desc = "CopilotChat - Inline chat",
        },
        -- Custom input for CopilotChat
        {
          "<leader>ai",
          function()
            local input = vim.fn.input("Ask Copilot: ")
            if input ~= "" then
              vim.cmd("CopilotChat " .. input)
            end
          end,
          desc = "CopilotChat - Ask input",
        },
        -- Generate commit message based on the git diff
        {
          "<leader>am",
          "<cmd>CopilotChatCommit<cr>",
          desc = "CopilotChat - Generate commit message for all changes",
        },
        {
          "<leader>aM",
          "<cmd>CopilotChatCommitStaged<cr>",
          desc = "CopilotChat - Generate commit message for staged changes",
        },
        -- Quick chat with Copilot
        {
          "<leader>aq",
          function()
            local input = vim.fn.input("Quick Chat: ")
            if input ~= "" then
              vim.cmd("CopilotChatBuffer " .. input)
            end
          end,
          desc = "CopilotChat - Quick chat",
        },
        -- Debug
        { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
        -- Fix the issue with diagnostic
        { "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
        -- Clear buffer and chat history
        { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
        -- Toggle Copilot Chat Vsplit
        -- { "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
        { "<leader>ta", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
      })
    end,
  },
}
