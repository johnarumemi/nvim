# NVIM config

This is just a repo that stores my nvim configuration

TODO: update this for use with Lazy.

## TODO Items

- Install [diffview](https://github.com/sindrets/diffview.nvim?tab=readme-ov-file).

## Environment Variables

```bash
NEORG_ENVIRONMENT= HOME | WORK
```

Sets default workspace when using `:Neorg workspace` with no specific
workspace specified.

## Useful links

- [Neovim rust setup and guide](https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/)
- [Lua Neovim Guide](https://neovim.io/doc/user/lua-guide.html#_introduction)
- [vim.tbl_deep_extend](https://neovim.io/doc/user/lua.html#vim.tbl_deep_extend%28%29)
- [window options](https://github.com/neovim/neovim/issues/24397#issuecomment-1650700549)

## Uninstall

See lazyvim github for uninstall instructions.

You can also delete directories via:

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
rm -rf ~/.local/state/nvim
```

or move them instead (backups):

```bash
mv ~/.local/share/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
```

### Swap files

These can be found at:

```bash
cd ~/.local/state/nvim/swap/
```

## Installation

### Requirements

- Yarn

```bash
npm install --global yarn
```

- Luarocks

```bash
brew install luarocks
```

- Stylua

```bash
brew install stylua
```

Alternatively Mason should install it for you.

### Manual Steps / Caveats

Add `mason/bin` to your `$PATH` environment variable. This is to enable
finding executables installed by Mason.

```bash
# .zprofile

# Neovim Mason bin directory
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
```

### Tagbar plugin

For this plugin to work (especially with rust) you should install the `universal ctags` binary. It conflicts with exuberant ctags and should be installed using the instructions below.

<https://github.com/universal-ctags/homebrew-universal-ctags>

See [wiki](https://github.com/preservim/tagbar/wiki#rust) for how to set this up.

Note that if you have exuberant-ctags etc installed, this conflicts with
universal-ctags, since installing universal-ctags creates / aliases `$(brew
--prefix)/bin/ctags`.

```bash
brew uninstall ctags 
brew install universal-ctags
```

### Fonts

<https://www.nerdfonts.com/font-downloads>

<https://gist.github.com/davidteren/898f2dcccd42d9f8680ec69a3a5d350e?permalink_comment_id=4058108#gistcomment-4058108>

```bash
brew tap homebrew/cask-fonts && \
brew install --cask font-inconsolata-nerd-font && \
brew install --cask font-inconsolata-lgc-nerd-font && \
brew install --cask font-roboto-mono-nerd-font && \
brew install --cask font-droid-sans-mono-nerd-font && \
brew install --cask font-hack-nerd-font && \
brew install --cask font-jetbrains-mono-nerd-font
```

## VS Code Integration

### Disabled Plugins

The following plugins are disabled when using Neovim within VS Code:

- bufferline: Tab management is handled by VS Code's interface
- dashboard-nvim: Start screen is redundant with VS Code
- gitsigns.nvim: Git decorations are managed by VS Code
- indent-blankline: Indentation guides are provided by VS Code
- lualine: Status line is not needed as VS Code has its own
- nvim-notify: Notifications are handled by VS Code
- nvim-tree: File explorer is provided by VS Code
- nvim-treesitter-context: VS Code provides similar functionality
- telescope: File searching is handled by VS Code
- which-key: Conflicts with VS Code's keyboard shortcuts

### Functionality Changes in VS Code Mode

When using Neovim within VS Code:

- LSP features like code completion, diagnostics, and formatting are provided by VS Code
- The color scheme adapts to VS Code's current theme
- Some keybindings are adjusted to prevent conflicts with VS Code shortcuts
- Terminal functionality is handled by VS Code's integrated terminal
- File navigation relies on VS Code's explorer and quick open features

## Neorg fonts

The required version of these fonts is at least v3.x.x for nerd fonts. Check
your version in brew or just do a greedy update:

```bash
brew upgrade --cask --greedy
```

## Neorg (possibly deprecated with 9.0.0)

On MacOS, you will get compilation errors if using the default gcc or clang.
You will need to install the brew gcc

```bash
brew install gcc
```

However, the above installed gcc binaries have versions as suffixes, i.e. `gcc-13`.
What you thus need to do is create symlinks that don't have these versions as suffixes.

```bash
ln -s $(brew --prefix)/bin/gcc-13 $(brew --prefix)/bin/gcc
```

Also ensure to update the `CC` environment variable to point to your symlinked gcc.

```bash
# zprofile.sh
export CC=$(brew --prefix)/bin/gcc
```

All the above will enable neorg to install correctly, you can test this via
manually running the treesitter grammar via:

```bash
nvim -c "TSInstallSync norg"
```

## Copilot

See `:help copilot` for further information.

NOTE: This plugin **qequires node >= v18**.

Other resources:

- [Main github copilot repo](https://github.com/github/copilot.vim) but
community also mentions the pure lua version found [here](https://github.com/zbirenbaum/copilot.lua)
- [Copilot completion](https://github.com/zbirenbaum/copilot-cmp)
- <https://tamerlan.dev/setting-up-copilot-in-neovim-with-sane-settings/>
- [CopilotChat](https://github.com/CopilotC-Nvim/CopilotChat.nvim)
- [Copilot lualine status symbol](https://github.com/AndreM222/copilot-lualine)
- [Learn copilot prompts](https://support.microsoft.com/en-gb/topic/learn-about-copilot-prompts-f6c3b467-f07c-4db1-ae54-ffac96184dd5)

## CopilotChat

Commands:

```bash
:CopilotChat <input>? - Open chat window with optional input
:CopilotChatOpen - Open chat window
:CopilotChatClose - Close chat window
:CopilotChatToggle - Toggle chat window
:CopilotChatStop - Stop current copilot output
:CopilotChatReset - Reset chat window
:CopilotChatSave <n>? - Save chat history to file
:CopilotChatLoad <n>? - Load chat history from file
:CopilotChatDebugInfo - Show debug information
```

Commands coming from default prompts:

```bash
:CopilotChatExplain - Write an explanation for the active selection as paragraphs of text
:CopilotChatReview - Review the selected code
:CopilotChatFix - There is a problem in this code. Rewrite the code to show it with the bug fixed
:CopilotChatOptimize - Optimize the selected code to improve performance and readability
:CopilotChatDocs - Please add documentation comment for the selection
:CopilotChatTests - Please generate tests for my code
:CopilotChatFixDiagnostic - Please assist with the following diagnostic issue in file
:CopilotChatCommit - Write commit message for the change with commitizen convention
:CopilotChatCommitStaged - Write commit message for the change with commitizen convention
```

## DAP

- [nvim-dap getting started](https://davelage.com/posts/nvim-dap-getting-started/)

## Mason

This is a package manager that is used for managing various development tools: it can
be installed and managed via Lazy. Development tools can include LSP **servers**,
which perform static analysis on the code sent into it by an LSP client.

### nvim-lspconfig

Neovim natively supports LSP clients, and provides a framework called vim.lsp for
developing LSP clients to communicate with an LSP server. nvim-lspconfig is simply
a plugin that holds the **configurations** for the neovim lsp client to communicate
with various lsp servers. The key word, as highlighted, is that it is configuring
the inbuilt native lsp client to communicate with specific lsp servers: it is not
the nvim lsp client itself!

### mason-lspconfig

So we have mason that can install various LSP servers, Neovim with an in-built
LSP client for communicating with a server and finally, nvim-lspconfig for actually
holding configurations for how the inbuilt LSP client can be configured to communicate
with a specific LSP server. mason-lspconfig acts as a bridge between mason and
nvim-lspconfig. It says "Hey! nvim-lspconfig has been configured to communicate with the rust-analyzer lsp server! lets use mason to ensure this server is installed,
if it is not installed, we can install it with mason!".

### package names

Now mason might have a package name for a given server, and then lspconfig
will have a config for a given server. The names between of the actual server
may differ between the lspconfig server name and the mason package name for the
server to be installed / communicated with. mason-lspconfig will translate
between the server names provided by lspconfig to the mason package names
(e.g. sumneko_lua <-> lua-language-server = lspconfig name <-> mason package name)

In the api's that mason-lspconfig uses, you should specify configurations
against an lsp client config or lsp server using the lspconfig name, not the mason
package name.

#### useful help docs

```vim
:h mason-lspconfig-automatic-server-setup
:h mason-lspconfig-settings
:h mason-lspconfig-server-map
```

## How-to

General helpful guidance.

### Finding file type

You can find the filetype ("dapui_watches", "dapui_breakpoints", etc.) by
moving the cursor to the window in question and running `:echo &ft`

### Changing highlights

Move your cursor under the text you want to alter the
highlight. Enter command mode and use `:Inspect` to get the
name of group.

Example:

```text
:Inspect

# Output

Treesitter
  - @spell.norg links to @spell norg
  - @neorg.markup.italic.norg links to @markup.italic norg
  - @neorg.markup.italic.norg links to @markup.italic norg
```

group name = @neorg.markup.italic.norg
highlight group linked to = @markup.italic

So if we want to create a new highlight group we can use the
following:

```lua
vim.cmd([[ highlight NeorgVerbatim guifg=cyan ]])
```

Above creates a highlight grouped called `NeorgVerbatim`.

We now need to link the group to it:

```lua
vim.cmd([[
  autocmd FileType norg
  highlight link @neorg.markup.verbatim.norg NeorgVerbatim
]])
```

Above creates an autocommand triggered on entering a norg
file. The autocommand will then call the following command,
`:highlight link @neorg.markup.verbatim.norg NeorgVerbatim`

## Troubleshooting

### Corrupted Sessions

Sometimes sessions are corrupted, and while there might be better ways of resolving this;
for now the best way is to just delete sessions found in `~/.local/share/nvim/sessions/`

### rust-analyzer issues

Rust-analyzer only supports the `stable` toolchain. If you have an override in
place from using `rustup default <some-non-stable-toolchain>` then it will fail
to understand the rust source. See `docs` link below for further information.

The only way I know to fix this is to explicitly set the below environment variable:

```bash
RUSTUP_TOOLCHAIN=stable nvim
```

- [rust-analyzer toolchain](https://rust-analyzer.github.io/manual.html#toolchain)
