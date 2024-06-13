# NVIM config
This is just a repo that stores my nvim configuration

TODO: update this for use with Lazy.

# Useful links

Neovim rust setup and guide
- https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/


# Uninstall
See lazyvim github for uninstall instructions.

You can also delete directories via,

`rm -rf ~/.local/share/nvim`
`rm ~/.cache/nvim`
`rm ~/.local/state/nvim`

or move them instead (backups),

`mv ~/.local/share/nvim{,.bak}`
`mv ~/.cache/nvim{,.bak}`
`mv ~/.local/state/nvim{,.bak}`


# Installation
## Manual Steps / Caveats
ensure you run following: 

~`Neorg sync-parser`~
~`MasonInstall stylua`~

Add `mason/bin` to your `$PATH` environment variable. This is to enable
finding executables installed by Mason.

```bash
# .zprofile

# Neovim Mason bin directory
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
```


## Tagbar plugin
For this plugin to work (especially with rust) you should install the `universal 
ctags` binary. It conflicts with exuberant ctags and 

https://github.com/universal-ctags/homebrew-universal-ctags

see [wiki](https://github.com/preservim/tagbar/wiki#rust) for how to set this up.

Note that if you have exuberant-ctags etc installed, this conflicts with
universal-ctags, since installing universal-ctags creates / aliases `$(brew
--prefix)/bin/ctags`.

```bash
brew uninstall ctags 
brew install universal-ctags

```
## Fonts
https://www.nerdfonts.com/font-downloads

https://gist.github.com/davidteren/898f2dcccd42d9f8680ec69a3a5d350e?permalink_comment_id=4058108#gistcomment-4058108

``````
brew tap homebrew/cask-fonts && \
brew install --cask font-inconsolata-nerd-font && \
brew install --cask font-inconsolata-lgc-nerd-font && \
brew install --cask font-roboto-mono-nerd-font && \
brew install --cask font-droid-sans-mono-nerd-font && \
brew install --cask font-hack-nerd-font && \
brew install --cask font-jetbrains-mono-nerd-font
``````

# Neorg
you require the v3.x.x for nerd fonts. Check your version in brew or just
do an greedy update
```
brew upgrade --cask --greedy
```

on MacOS, you will get compilation errors if using the default gcc or clang.
You will need to install the brew gcc
```
brew install gcc
```

However, the above installed gcc binaries have versions as suffixes, i.e. `gcc-13`.
What you thus need to do is create symlinks that don't have these versions as suffixes.

```
ln -s $(brew --prefix)/bin/gcc-13 $(brew --prefix)/bin/gcc
```
Also ensure to update the `CC` environment variable to point to your symlinked gcc.

```
# zprofile.sh
export CC=$(brew --prefix)/bin/gcc
```
All the above will enable neorg to install correctly, you can test this via 
manually running the treesitter grammer via:
```bash
nvim -c "TSInstallSync norg"
```

# Copilot

see `:help copilot` for further information.

**Requires node >= v18**

other resources:
- [Main github copilot repo](https://github.com/github/copilot.vim) but
community also mentions the pure lua version found [here](https://github.com/zbirenbaum/copilot.lua)
- [Copilot completion](https://github.com/zbirenbaum/copilot-cmp)
- https://tamerlan.dev/setting-up-copilot-in-neovim-with-sane-settings/
- [CopilotChat](https://github.com/CopilotC-Nvim/CopilotChat.nvim)
- [Copilot lualine status symbol](https://github.com/AndreM222/copilot-lualine)
- [Learn copilot prompts](https://support.microsoft.com/en-gb/topic/learn-about-copilot-prompts-f6c3b467-f07c-4db1-ae54-ffac96184dd5)


# CopilotChat
Commands
```
:CopilotChat <input>? - Open chat window with optional input
:CopilotChatOpen - Open chat window
:CopilotChatClose - Close chat window
:CopilotChatToggle - Toggle chat window
:CopilotChatStop - Stop current copilot output
:CopilotChatReset - Reset chat window
:CopilotChatSave <name>? - Save chat history to file
:CopilotChatLoad <name>? - Load chat history from file
:CopilotChatDebugInfo - Show debug information
```
Commands coming from default prompts
```
:CopilotChatExplain - Write an explanation for the active selection as paragraphs of text
:CopilotChatReview - Review the selected code
:CopilotChatFix - There is a problem in this code. Rewrite the code to show it with the bug fixed
:CopilotChatOptimize - Optimize the selected code to improve performance and readablilty
:CopilotChatDocs - Please add documentation comment for the selection
:CopilotChatTests - Please generate tests for my code
:CopilotChatFixDiagnostic - Please assist with the following diagnostic issue in file
:CopilotChatCommit - Write commit message for the change with commitizen convention
:CopilotChatCommitStaged - Write commit message for the change with commitizen convention
```

# mason
This is a package manager that is used for managing various development tools: it can
be installed and managed via Packer. Development tools can include LSP **servers**,
which perform static analysis on the code sent into it by an LSP client. 

### nvim-lspconfig
Neovim natively supports LSP clients, and provides a framework called vim.lsp for
developing LSP clients to communicate with an LSP server. nvim-lspconfig is simply
a pluging that holds the **configurations** for the neovim lsp client to communicate
with various lsp servers. The key word, as highlighted, is that it is configuring
the inbuilt native lsp client to communicate with specific lsp servers: it is not
the nvim lsp client itself! 


### mason-lspconfig
So we have mason that can install various LSP servers, Neovim with an in-built
LSP client for communicating with a server and finally,  nvim-lspconfig for actually
holding configurations for how the inbuilt LSP client can configured to communicate
with a specific LSP server. mason-lspconfig acts as a bridge between mason and 
nvim-lspconfig. It says "Hey! nvim-lspconfig has been configured to communicate with
the rust-analyzer lsp server! lets use mason to ensure this server is installed, 
if it is not installed, we can install it with mason!".

### package names

now mason might have a package name for a given server, and then lspconfig
will have a config for a given server. The names between of the actual server
may differ between the lspconfig server name and the mason package name for the
server to be installed / communicated with. mason-lspconfig will translate
between the server names provided by lspconfig to the mason package names
(e.g. sumneko_lua <-> lua-language-server = lspconfig name <-> mason package name)

In the api's that mason-lspconfig uses, you should specifiy configurations
against an lsp cient config or lsp server using the lspconfig name, not the mason
package name.

#### useful help docs
```
:h mason-lspconfig-automatic-server-setup
:h mason-lspconfig-settings
:h mason-lspconfig-server-map
```

# Troubleshooting

## Corrupted Sessions
sometimes sessions are corrupted, and while there might be better ways of resolving this;
for now the best way is to just delete sessions found in `~/.local/share/nvim/sessions/`
