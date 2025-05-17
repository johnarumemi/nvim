-- NOTE: any prompts you place here are directly available as commands,
-- prefixed with `CopilotChat`.
-- So a prompt of "DoSomething", will be available as `:CopilotChatDoSomething`.
-- Reference them with /PromptName in chat, use :CopilotChat<PromptName> or
-- :CopilotChatPrompts to select them:

local utils = require("jai.plugins.core.ai.copilot-chat.utils")
local prompts = require("jai.plugins.core.ai.copilot-chat.prompts")
local commands = require("jai.plugins.core.ai.copilot-chat.commands")

return {
  {
    -- repo: https://github.com/CopilotC-Nvim/CopilotChat.nvim
    --
    "CopilotC-Nvim/CopilotChat.nvim",
    -- Disable CopilotChat in VS Code as it has its own Copilot Chat
    enabled = function()
      return not vim.g.vscode
    end,
    -- Do not use branch and version together, either use branch or version
    version = "v3.12.0",
    -- branch = "main",
    -- branch = "canary", -- Use the canary branch if you want to test the latest features but it might be unstable
    event = "VeryLazy",
    dependencies = {
      { "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      agent = "copilot",
      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
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

      -- Merge the prompts with the ones created using the dependencies
      opts.prompts = vim.tbl_deep_extend("force", opts.prompts or {}, prompts.create_prompts(select, context))

      chat.setup(opts)

      -- DEPRECATED: Not working after moving from v2 to v3
      -- Setup the CMP integration
      -- require("CopilotChat.integrations.cmp").setup()

      -- Register custom commands and get their mappings
      local custom_mappings = commands.create_custom_commands(chat, select, context)

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

      -- Additional functional mappings that aren't directly tied to commands
      local additional_mappings = {
        -- Group definition
        { "<leader>a", group = "Copilot Chat" },

        -- Show available prompts with telescope
        {
          "<leader>ap",
          function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
          end,
          desc = "CopilotChat - Show prompt actions in telescope",
        },

        -- Quick chat with Copilot
        {
          "<leader>aq",
          function()
            local input = vim.fn.input("Quick Chat: ")
            if input ~= "" then
              -- NOTE: CopilotChatBuffer is a custom command defined
              -- in my configuration.
              vim.cmd("CopilotChatBuffer " .. input)
            end
          end,
          desc = "CopilotChat - Quick chat",
        },
      }

      -- Combine additional mappings with custom command mappings
      local all_mappings = vim.tbl_deep_extend("force", additional_mappings, custom_mappings)

      -- Register all mappings with which-key
      wk.add(all_mappings)
    end,
  },
}
