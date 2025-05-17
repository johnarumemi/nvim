-- NOTE: any prompts you place here are directly available as commands, prefixed with `CopilotChat`.
-- So a prompt of "DoSomething", will be available as `:CopilotChatDoSomething`.
-- Reference them with /PromptName in chat, use :CopilotChat<PromptName> or
-- :CopilotChatPrompts to select them:

-- Helper function to create custom commands and register their mappings
---@param name string The name of the command (without CopilotChat prefix)
---@param func function The function to execute when the command is called
---@param command_opts table Options for nvim_create_user_command
---@param mapping_opts table|nil Options for which-key registration (mapping, description, mode)
---@return table|nil which-key entry if mapping provided, nil otherwise
local function create_custom_command(name, func, command_opts, mapping_opts)
  vim.api.nvim_create_user_command("CopilotChat" .. name, func, command_opts)

  if mapping_opts and mapping_opts.mapping then
    local wk_entry = {
      mapping_opts.mapping,
      mapping_opts.command or ("<cmd>CopilotChat" .. name .. "<cr>"),
      desc = mapping_opts.description or ("CopilotChat - " .. name),
    }

    if mapping_opts.mode then
      wk_entry.mode = mapping_opts.mode
    end

    return wk_entry
  end

  return nil
end

-- Function to define and register all custom commands
---@param chat table CopilotChat module
---@param select table CopilotChat.select module
---@param context table CopilotChat.context module
---@return table Table of which-key mapping entries
local function create_custom_commands(chat, select, context)
  local commands = {
    -- Command: CopilotChatVisual
    -- Description: Ask Copilot about the current visual selection
    Visual = {
      func = function(args)
        chat.ask(args.args, { selection = select.visual })
      end,
      command_opts = { nargs = "*", range = true },
      mapping_opts = nil, -- No default mapping
    },

    -- Command: CopilotChatBuffer
    -- Description: Ask Copilot about the entire current buffer
    -- Usage: :CopilotChatBuffer [prompt]
    Buffer = {
      func = function(args)
        chat.ask(args.args, { selection = select.buffer })
      end,
      command_opts = { nargs = "*", range = true },
      -- no defualt mapping, but this command may be used by otherj
      -- commands that have a mapping
      mapping_opts = {},
    },

    -- Command: CopilotChatInline
    -- Description: Shows Copilot's response in a floating window near the cursor
    -- Usage: :'<,'>CopilotChatInline [prompt]
    -- Mapping: <leader>ax (visual mode)
    Inline = {
      func = function(args)
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
      end,
      command_opts = { nargs = "*", range = true },
      mapping_opts = {
        mapping = "<leader>ax",
        description = "Inline chat",
        mode = "x",
      },
    },

    -- Command: CopilotChatReset
    -- Description: Clears the chat history and buffer
    -- Usage: :CopilotChatReset
    Reset = {
      func = function() end, -- Just use the built-in command
      command_opts = { nargs = 0 },
      mapping_opts = {
        mapping = "<leader>al",
        description = "Clear buffer and chat history",
      },
    },

    -- Command: CopilotChatToggle
    -- Description: Toggles the Copilot Chat panel
    -- Usage: :CopilotChatToggle
    Toggle = {
      func = function() end, -- Just use the built-in command
      command_opts = { nargs = 0 },
      mapping_opts = {
        mapping = "<leader>ta",
        description = "Toggle",
      },
    },
  }

  local mappings = {}

  -- Register all commands and collect mappings
  for name, cmd_def in pairs(commands) do
    local mapping = create_custom_command(name, cmd_def.func, cmd_def.command_opts, cmd_def.mapping_opts)

    if mapping then
      table.insert(mappings, mapping)
    end
  end

  return mappings
end
-- Define a function to create prompts with the required format and dependencies
---@param select CopilotChat.select Table containing selection methods like visual, buffer, and unnamed
---@param context CopilotChat.context
---@return table Table of prompt definitions
local create_prompts = function(select, context)
  return {
    -- Code related prompts
    BetterNamings = {
      prompt = "Provide better names for the following variables, functions, types and modules.",
      system_prompt = "You are an expert programmer with a talent for clear, descriptive naming conventions.",
      mapping = "<leader>an",
      description = "Get better variable and function names",
    },
    Documentation = {
      prompt = "Provide documentation for the following code.",
      system_prompt = "You are an expert technical writer who writes clear and comprehensive code documentation.",
      mapping = "<leader>ad",
      description = "Generate documentation for code",
    },
    Explain = {
      prompt = "Explain how the following code works.",
      system_prompt = "You are very good at explaining code",
      mapping = "<leader>ae",
      description = "Explain how code works",
    },
    DebugInfo = {
      prompt = "Provide debugging information for the following code.",
      system_prompt = "You are an expert debugger who can identify potential issues in code.",
      mapping = "<leader>ad",
      description = "Get debugging information",
    },
    FixCode = {
      prompt = "Fix the following code to make it work as intended.",
      system_prompt = "You are an expert programmer who can identify and fix code issues.",
      mapping = "<leader>af",
      description = "Fix code issues",
    },
    FixError = {
      prompt = "Explain the error in the following text and provide a solution.",
      system_prompt = "You are an expert at diagnosing and solving programming errors.",
      mapping = "<leader>af",
      description = "Explain and fix errors",
    },
    Refactor = {
      prompt = "Refactor the following code to improve its clarity and readability.",
      system_prompt = "You are an expert at code refactoring and clean code principles.",
      mapping = "<leader>aR",
      description = "Refactor code for clarity",
    },
    Review = {
      prompt = "Review the following code and provide suggestions for improvement.",
      system_prompt = "You are a senior code reviewer with a keen eye for code quality and best practices.",
      mapping = "<leader>ar",
      description = "Review code and suggest improvements",
    },
    SwaggerApiDocs = {
      prompt = "Provide documentation for the following API using Swagger.",
      system_prompt = "You are an expert at creating detailed Swagger API documentation.",
      mapping = "<leader>as",
      description = "Generate Swagger API documentation",
    },
    SwaggerJsDocs = {
      prompt = "Write JSDoc for the following API using Swagger.",
      system_prompt = "You are an expert at creating clear JSDoc with Swagger annotations.",
      mapping = "<leader>aj",
      description = "Generate JSDoc with Swagger",
    },
    Tests = {
      prompt = "Explain how the selected code works, then generate unit tests for it.",
      system_prompt = "You are an expert at understanding code and writing comprehensive unit tests.",
      mapping = "<leader>at",
      description = "Generate unit tests for code",
    },
    -- Text related prompts
    Concise = {
      prompt = "Rewrite the following text to make it more concise.",
      system_prompt = "You are an expert editor who specializes in making text clear and concise.",
      mapping = "<leader>ac",
      description = "Make text more concise",
    },
    Spelling = {
      prompt = "Correct any grammar and spelling errors in the following text.",
      system_prompt = "You are an expert proofreader with perfect grammar and spelling skills.",
      mapping = "<leader>as",
      description = "Fix grammar and spelling",
    },
    Summarize = {
      prompt = "Summarize the following text.",
      system_prompt = "You are an expert at creating concise and accurate summaries of complex text.",
      mapping = "<leader>as",
      description = "Summarize text",
    },
    Wording = {
      prompt = "Improve the grammar and wording of the following text.",
      system_prompt = "You are an expert editor who can improve the clarity and flow of any text.",
      mapping = "<leader>aw",
      description = "Improve text wording and grammar",
    },
    -- Git prompts that require dependencies
    Commit = select
      and {
        prompt = "Write commit message for all changes with commitizen convention",
        system_prompt = "You are an expert at writing clear, concise commit messages following commitizen conventions.",
        mapping = "<leader>am",
        description = "Generate commit message for all changes",
        selection = function()
          return vim.fn.system("git diff")
        end,
      },
    CommitStaged = select
      and {
        prompt = "Write commit message for staged changes with commitizen convention",
        system_prompt = "You are an expert at writing clear, concise commit messages following commitizen conventions.",
        mapping = "<leader>aM",
        description = "Generate commit message for staged changes",
        selection = function()
          return vim.fn.system("git diff --staged")
        end,
      },
    SortByKeys = select and {
      prompt = "Please sort the following by keys alphabetically, in ascending order.",
      system_prompt = "You are an expert at organizing and sorting data structures.",
      mapping = "<leader>aks",
      description = "Sort by keys alphabetically",
      selection = select and select.visual,
    },
  }
end

return {

  {
    -- INFO: Use `:help copilot` for documentation of setup of copilot-cmp
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

        -- It is recommended to disable copilot.lua's suggestion and panel modules, as
        -- they can interfere with completions properly appearing in copilot-cmp. To do
        -- so, simply place the following in your copilot.lua config:
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    -- repo: https://github.com/zbirenbaum/copilot-cmp
    --
    -- turns `zbirenbaum/copilot.lu` into a completion source, rather than have
    -- it pollute your inline text insertions.
    --
    -- NOTE: part of configuring this involves adding it as a source to nvim-cmp.
    -- So if uninstalling, ensure that it is removed from there as well.
    "zbirenbaum/copilot-cmp",
    enabled = function()
      -- Disable Copilot CMP in VS Code
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
      opts.prompts = vim.tbl_deep_extend("force", opts.prompts or {}, create_prompts(select, context))

      chat.setup(opts)

      -- DEPRECATED: Not working after moving from v2 to v3
      -- Setup the CMP integration
      -- require("CopilotChat.integrations.cmp").setup()

      -- Register custom commands and get their mappings
      local custom_mappings = create_custom_commands(chat, select, context)

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

        -- Show availabe prompts with telescope
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
