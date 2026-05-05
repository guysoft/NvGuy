<div align="center">
  <h1>🚀 nvguy - Neovim Distribution</h1>
  <p>A modern, feature-rich Neovim configuration based on NvChad</p>
  
  [![Neovim](https://img.shields.io/badge/Neovim-0.9+-green.svg)](https://neovim.io/)
  [![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
  [![Stars](https://img.shields.io/github/stars/guysoft/nvguy.svg)](https://github.com/guysoft/nvguy/stargazers)
</div>

---

## ✨ Features

### 🎨 Visual
- **Theme**: [Fluoromachine](https://github.com/maxmx03/fluoromachine.nvim) - A retro-futuristic color scheme
- **Status Line**: Custom NvChad statusline with LSP, git, and diagnostic indicators
- **Icons**: Full [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) support
- **File Tree**: [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) with enhanced navigation
- **Syntax Highlighting**: Treesitter-powered highlighting for 100+ languages
- **Indentation**: Visual indentation guides with [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)

### 🛠️ Development
- **LSP**: Native LSP with [mason.nvim](https://github.com/williamboman/mason.nvim) for language servers
- **Auto-completion**: [NvChad nvim-cmp](https://github.com/NvChad/nvim-cmp) with snippet support
- **Code Formatting**: [Conform.nvim](https://github.com/stevearc/conform.nvim) for code formatting
- **Linting**: Integrated linting for multiple languages
- **Debugging**: [nvim-dap](https://github.com/mfussenegger/nvim-dap) with [dap-ui](https://github.com/rcarriga/nvim-dap-ui), virtual-text values, and [debugpy](https://github.com/microsoft/debugpy) for Python — driveable from the [`guyide`](https://github.com/guysoft/guyide-cli) CLI via [vscodium.nvim](https://github.com/guysoft/vscodium.nvim)'s `nvim-launch.debug-rpc`
- **Git Integration**: [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) for git status in buffer
- **Git Client**: [Neogit](https://github.com/NeogitOrg/neogit) for git operations
- **File Explorer**: Enhanced Neo-tree
- **Terminal**: [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) for integrated terminal
- **Sessions**: [Persistence.nvim](https://github.com/olimorris/persisted.nvim) for session management

### 🚀 Productivity
- **Fuzzy Finder**: [Telescope](https://github.com/nvim-telescope/telescope.nvim) with multiple picker extensions
- **Project Management**: [project.nvim](https://github.com/ahmedkhalf/project.nvim)
- **Quick UI**: [Quick-UI.nvim](https://github.com/skywind3000/quickui.nvim) for popup interfaces
- **Color Picker**: [Pickachu.nvim](https://github.com/lpoto/pickachu.nvim)
- **Media Viewer**: [Image.nvim](https://github.com/3rd/image.nvim)
- **Dashboard**: Custom NvChad dashboard
- **Window Management**: [nvim-window-picker](https://github.com/s1n7ax/nvim-window-picker)

### 📦 Custom Plugins
- **BetterQuickfix**: Enhanced quickfix list with [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf)
- **Colorizer**: [nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) for hex colors
- **Scrollview**: [nvim-scrollview](https://github.com/dstein64/nvim-scrollview) for minimap
- **Cheatsheet**: Interactive cheatsheet

---

## 📸 Screenshots

### Dashboard
*A clean dashboard greets you when opening Neovim*

### LSP in Action
*Syntax highlighting, diagnostics, and hover information*

### Git Integration
*See your changes, blame, and preview changes*

### Telescope
*Fuzzy find files, grep, and navigate your project*

### File Explorer
*Navigate your file system with ease*

---

## 🚀 Installation

### Prerequisites

- **Neovim** >= 0.9.0
- **Git** >= 2.19.0 (for partial clones)
- **Nerd Font** (Optional: for icons)
- **C Compiler** (for treesitter)

### Quick Install

1. **Backup your current Neovim config:**
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. **Clone the distribution:**
```bash
git clone --depth 1 https://github.com/guysoft/nvguy.git ~/.config/nvim
```

3. **Run Neovim and let it install plugins:**
```bash
nvim
```

4. **Install language servers:**
```
:MasonInstallAll
```

### Automated Install

For a fully automated installation including prerequisites:

```bash
wget -O- https://raw.githubusercontent.com/guysoft/nvguy/main/install.sh | bash
```

Or download and run:

```bash
curl -fsSL https://raw.githubusercontent.com/guysoft/nvguy/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

---

## ⚙️ Configuration

### Customizing the Distribution

The configuration is modular and easy to customize:

1. **Add new plugins** in `lua/plugins/init.lua`
2. **Modify mappings** in `lua/mappings.lua`
3. **Change options** in `lua/options.lua`
4. **Customize LSP** in `lua/configs/lspconfig.lua`

### Key Bindings

#### General
| Key | Action |
|-----|--------|
| `<C-n>` | Toggle Neotree |
| `<leader>ff` | Telescope find files |
| `<leader>fg` | Telescope live grep |
| `<leader>fb` | Telescope buffers |
| `<leader>fh` | Telescope help tags |
| `<leader>e` | Toggle Neotree |
| `<leader>ff` | Telescope find files |
| `<leader>fg` | Telescope live grep |
| `<leader>fb` | Telescope buffers |
| `<leader>fh` | Telescope help tags |
| `<leader>fb` | Telescope file browser |
| `<leader>fs` | Telescope search sessions |
| `<leader>ft` | Telescope file types |
| `<leader>fc` | Telescope colorschemes |
| `<leader>fp` | Telescope projects |
| `<leader>fk` | Telescope keymaps |
| `<leader>fr` | Telescope resume |

#### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `K` | Hover information |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `<leader>f` | Format document |

#### Git (Neogit)
| Key | Action |
|-----|--------|
| `<leader>gg` | Open Neogit |
| `<leader>gl` | Open lazygit |

#### Terminal
| Key | Action |
|-----|--------|
| `<C-\>` | Toggle terminal |
| `<A-i>` | Floating terminal |
| `<A-h>` | Terminal left |
| `<A-v>` | Terminal down |

#### Window Management
| Key | Action |
|-----|--------|
| `<C-h>` | Navigate left |
| `<C-l>` | Navigate right |
| `<C-k>` | Navigate up |
| `<C-j>` | Navigate down |
| `<C-Up>` | Resize up |
| `<C-Down>` | Resize down |
| `<C-Left>` | Resize left |
| `<C-Right>` | Resize right |

#### Quick UI
| Key | Action |
|-----|--------|
| `<leader>u` | Open Quick UI |
| `<leader>ck` | Color picker |

#### Cheatsheet
| Key | Action |
|-----|--------|
| `<leader>ch` | Cheatsheet |

#### Sessions
| Key | Action |
|-----|--------|
| `<leader>qa` | Save current session |
| `<leader>qs` | View session list |

#### Git (Gitsigns)
| Key | Action |
|-----|--------|
| `<leader>ph` | Preview hunk |
| `<leader>rh` | Reset hunk |
| `<leader>gb` | Toggle blame |
| `<leader>gd` | Toggle deleted |

---

## 📦 Plugin List

### Core
- [NvChad](https://github.com/NvChad/NvChad) - Base framework
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder

### UI
- [Fluoromachine](https://github.com/maxmx03/fluoromachine.nvim) - Theme
- [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) - File explorer
- [NvChad/nvim-colorizer.lua](https://github.com/nvchad/nvim-colorizer.lua) - Color highlighter
- [NvChad/nvim-dap-ui](https://github.com/nvchad/nvim-dap-ui) - DAP UI
- [NvChad/nvim-notify](https://github.com/nvchad/nvim-notify) - Notifications

### LSP & Completion
- [Mason.nvim](https://github.com/williamboman/mason.nvim) - LSP manager
- [NvChad/nvim-cmp](https://github.com/nvchad/nvim-cmp) - Autocompletion
- [Conform.nvim](https://github.com/stevearc/conform.nvim) - Code formatting
- [NvChad/nvim-lspconfig](https://github.com/nvchad/nvim-lspconfig) - LSP configs

### Git
- [Gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git signs
- [Neogit](https://github.com/NeogitOrg/neogit) - Git client
- [Diffview.nvim](https://github.com/sindrets/diffview.nvim) - Diff viewer
- [Git-blame.nvim](https://github.com/f-person/git-blame.nvim) - Git blamer

### Git & Tmux Navigation
- [Vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) - Seamless navigation

### Treesitter
- [Nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting
- [Nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- [Nvim-treesitter-refactor](https://github.com/nvim-treesitter/nvim-treesitter-refactor)

### Terminal & Sessions
- [Toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) - Terminal
- [Persistence.nvim](https://github.com/olimorris/persisted.nvim) - Sessions

### Quick UI & Others
- [Quick-UI.nvim](https://github.com/skywind3000/quickui.nvim) - Quick UI
- [Pickachu.nvim](https://github.com/lpoto/pickachu.nvim) - Color picker
- [Image.nvim](https://github.com/3rd/image.nvim) - Media viewer
- [Nvim-scrollview](https://github.com/dstein64/nvim-scrollview) - Minimap
- [Nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) - Better quickfix

---

## 🐛 Troubleshooting

### Plugin Installation Fails
```bash
rm -rf ~/.local/share/nvim/lazy
nvim
```

### LSP Not Working
Run `:MasonInstallAll` to install all language servers

### Treesitter Errors
```bash
:TSUninstall all
:TSInstall all
```

### Cache Issues
```bash
rm -rf ~/.cache/nvim
```

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=guysoft/NvGuy&type=Date)](https://star-history.com/#guysoft/NvGuy&Date)

---

## 💬 Support

- Create an [Issue](https://github.com/guysoft/NvGuy/issues) for bug reports
- Start a [Discussion](https://github.com/guysoft/NvGuy/discussions) for questions

---

<div align="center">

**Made with ❤️ by [Guy Sheffer](https://github.com/guysoft)**

If you like this project, please give it a ⭐!

</div>

---

*This is a distribution based on [NvChad](https://github.com/NvChad/NvChad). Check out the original project for more information.*