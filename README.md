# NVIM config
This is just a repo that stores my nvim configuration

# Uninstall

Since everything is insalled with `packer`, simply
delete all installed packer plugins directly via following:
```shell

rm -rf site/pack/packer/opt/
rm -rf site/pack/packer/start/
```

# Installation
## Manual Steps / Caveats
ensure you run following: 

`Neorg sync-parser`
`MasonInstall stylua`

## Tagbar plugin
For this plugin to work (especially with rust) you should install the universal 
`ctags` binary.

https://github.com/universal-ctags/homebrew-universal-ctags

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
on MacOS, you will get compilation errors if using the default gcc or clang.
You will need to install the brew gcc
```
brew install gcc
```

However, the above installed gcc binaries have versions as suffixes, i.e. `gcc-13`.
What you thus need to do is create symlinks that don't have these versions as suffixes.

```
ln -s $(brew --prefix)/bin/gcc-13 $(brew --prefix)/bi/gcc
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

