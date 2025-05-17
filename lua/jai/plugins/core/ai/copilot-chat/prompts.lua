-- Prompts definitions for CopilotChat
--
-- This module defines the various prompts that can be used with CopilotChat.
-- It provides a function to create the prompts with proper structure.
--
-- @module jai.plugins.core.ai.copilot-chat.prompts

---@class PromptDefinition
---@field prompt string The prompt text to send to Copilot
---@field system_prompt string The system prompt that defines Copilot's behavior
---@field mapping string The keybinding for this prompt
---@field description string Short description of what this prompt does
---@field selection? function Optional function to get the selection

-- Define a function to create prompts with the required format and dependencies
---@param select CopilotChat.select Table containing selection methods like visual, buffer, and unnamed
---@param context CopilotChat.context
---@return table<string, PromptDefinition> Table of prompt definitions
local function create_prompts(select, context)
  return {
    -- Code related prompts
    BetterNamings = {
      prompt = "Provide better names for the following variables, functions, types and modules.",
      system_prompt = "You are an expert programmer with a talent for clear, descriptive naming conventions.",
      mapping = "<leader>apn",
      description = "Get better variable and function names",
    },
    Documentation = {
      prompt = "Provide documentation for the following code.",
      system_prompt = "You are an expert technical writer who writes clear and comprehensive code documentation.",
      mapping = "<leader>apd",
      description = "Generate documentation for code",
    },
    Explain = {
      prompt = "Explain how the following code works.",
      system_prompt = "You are very good at explaining code",
      mapping = "<leader>ape",
      description = "Explain how code works",
    },
    DebugInfo = {
      prompt = "Provide debugging information for the following code.",
      system_prompt = "You are an expert debugger who can identify potential issues in code.",
      mapping = "<leader>apd",
      description = "Get debugging information",
    },
    FixCode = {
      prompt = "Fix the following code to make it work as intended.",
      system_prompt = "You are an expert programmer who can identify and fix code issues.",
      mapping = "<leader>apf",
      description = "Fix code issues",
    },
    FixError = {
      prompt = "Explain the error in the following text and provide a solution.",
      system_prompt = "You are an expert at diagnosing and solving programming errors.",
      mapping = "<leader>apf",
      description = "Explain and fix errors",
    },
    Refactor = {
      prompt = "Refactor the following code to improve its clarity and readability.",
      system_prompt = "You are an expert at code refactoring and clean code principles.",
      mapping = "<leader>apR",
      description = "Refactor code for clarity",
    },
    Review = {
      prompt = "Review the following code and provide suggestions for improvement.",
      system_prompt = "You are a senior code reviewer with a keen eye for code quality and best practices.",
      mapping = "<leader>apr",
      description = "Review code and suggest improvements",
    },
    SwaggerApiDocs = {
      prompt = "Provide documentation for the following API using Swagger.",
      system_prompt = "You are an expert at creating detailed Swagger API documentation.",
      mapping = "<leader>aps",
      description = "Generate Swagger API documentation",
    },
    SwaggerJsDocs = {
      prompt = "Write JSDoc for the following API using Swagger.",
      system_prompt = "You are an expert at creating clear JSDoc with Swagger annotations.",
      mapping = "<leader>apj",
      description = "Generate JSDoc with Swagger",
    },
    Tests = {
      prompt = "Explain how the selected code works, then generate unit tests for it.",
      system_prompt = "You are an expert at understanding code and writing comprehensive unit tests.",
      mapping = "<leader>apt",
      description = "Generate unit tests for code",
    },
    -- Text related prompts
    Concise = {
      prompt = "Rewrite the following text to make it more concise.",
      system_prompt = "You are an expert editor who specializes in making text clear and concise.",
      mapping = "<leader>apc",
      description = "Make text more concise",
    },
    Spelling = {
      prompt = "Correct any grammar and spelling errors in the following text.",
      system_prompt = "You are an expert proofreader with perfect grammar and spelling skills.",
      mapping = "<leader>aps",
      description = "Fix grammar and spelling",
    },
    Summarize = {
      prompt = "Summarize the following text.",
      system_prompt = "You are an expert at creating concise and accurate summaries of complex text.",
      mapping = "<leader>aps",
      description = "Summarize text",
    },
    Wording = {
      prompt = "Improve the grammar and wording of the following text.",
      system_prompt = "You are an expert editor who can improve the clarity and flow of any text.",
      mapping = "<leader>apw",
      description = "Improve text wording and grammar",
    },
    -- Git prompts that require dependencies
    Commit = select
      and {
        prompt = "Write commit message for all changes with commitizen convention",
        system_prompt = "You are an expert at writing clear, concise commit messages following commitizen conventions.",
        mapping = "<leader>apm",
        description = "Generate commit message for all changes",
        selection = function()
          return vim.fn.system("git diff")
        end,
      },
    CommitStaged = select
      and {
        prompt = "Write commit message for staged changes with commitizen convention",
        system_prompt = "You are an expert at writing clear, concise commit messages following commitizen conventions.",
        mapping = "<leader>apM",
        description = "Generate commit message for staged changes",
        selection = function()
          return vim.fn.system("git diff --staged")
        end,
      },
    SortByKeys = select and {
      prompt = "Please sort the following by keys alphabetically, in ascending order.",
      system_prompt = "You are an expert at organizing and sorting data structures.",
      mapping = "<leader>aps",
      description = "Sort by keys alphabetically",
      selection = select and select.visual,
    },
  }
end

return {
  create_prompts = create_prompts,
}
