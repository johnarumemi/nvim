-- Prompts definitions for CopilotChat
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
  create_prompts = create_prompts,
}

