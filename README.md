# NvGuy - Neovim Distribution

A Neovim distribution based on NvChad with a full menu bar system

[![Neovim](https://img.shields.io/badge/Neovim-0.9+-green.svg)](https://neovim.io/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Stars](https://img.shields.io/github/stars/guysoft/NvGuy.svg)](https://github.com/guysoft/NvGuy/stargazers)

---

![QuickUI Menu Demo](screenshots/quickui-menu.gif)

## What is this?

NvGuy adds a traditional **menu bar** to Neovim via [vim-quickui](https://github.com/guysoft/vim-quickui), sitting on top of [NvChad](https://github.com/NvChad/NvChad). Press `F10` or `<leader>m` and get a full File/Edit/View/Git/Tools menu — no need to memorize every keybinding.

## Features

- **Full menu bar** with 13 menus covering file ops, editing, git, diagnostics, sessions, tools, window management, and more
- **Right-click style context menu** for LSP actions (go to definition, references, rename, code actions)
- **Git integration** via Gitsigns (inline blame, hunk operations) and Neogit (magit-style UI)
- **Code minimap** sidebar via mini.map
- **Session management** with auto-save per directory via possession.nvim
- **Code formatting** via conform.nvim
- **LSP support** via nvim-lspconfig (language servers managed by Mason from NvChad)
- **Everything from NvChad**: Telescope, Treesitter, nvim-cmp, Mason, nvim-tree, and more

---

## Menu Map

Press `F10` or `<leader>m` to open the menu bar. Here's what's inside:

```
 File │ Edit │ View │ Git │ Tools │ Window │ Marks │ Jumps │ Spell │ History │ Options │ Help
```

### File — New, Open, Save, Sessions, Recent Files, Quit

| Item | Command |
|------|---------|
| New File | `enew` |
| Open | `Telescope find_files` |
| Save / Save As | `write` / `:saveas` |
| Save Session | `:SSave` prompt |
| Recent Sessions | Dynamic submenu (top 5 by project) |
| Recent Files | `Telescope oldfiles` |
| Close / Quit | `close` / `quit` |

### Edit — Undo, Redo, Clipboard, Find, Replace, File Operations

| Item | Command |
|------|---------|
| Undo / Redo | `undo` / `redo` |
| Cut / Copy / Paste | System clipboard (`"+x`, `"+y`, `"+p`) |
| Find | `Telescope live_grep` |
| Find and Replace | `:%s/` prompt |
| File Operations | Submenu: file info, path, word count, encoding, format |
| Search/Replace | Submenu: search, next/prev match, replace, replace in selection |

### View — File Explorer, Buffers, Symbols, Diagnostics, Quickfix

| Item | Command |
|------|---------|
| File Explorer | `NvimTreeToggle` |
| Buffers | `Telescope buffers` |
| Symbols | `Telescope lsp_document_symbols` |
| Diagnostics | `Telescope diagnostics` |
| Quickfix | `copen` |

### Git — Neogit, Telescope git pickers, Gitsigns hunk operations

| Item | Command |
|------|---------|
| Neogit | `Neogit` (magit-style interface) |
| Status / Commits / Branches | `Telescope git_*` |
| Diff | `Gitsigns diffthis` |
| Blame Line | `gitsigns.blame_line` (full) |
| Toggle Line Blame | `Gitsigns toggle_current_line_blame` |
| Preview / Reset / Stage Hunk | `Gitsigns preview_hunk` / `reset_hunk` / `stage_hunk` |

### Tools — Terminal, Lazy, Mason, Commands, Keymaps, Help

| Item | Command |
|------|---------|
| Terminal | `terminal` |
| Lazy | `Lazy` (plugin manager) |
| Mason | `Mason` (LSP installer) |
| Commands / Keymaps / Help | `Telescope commands` / `keymaps` / `help_tags` |

### Window — Split, Close, Equalize, Maximize, Rotate

| Item | Command |
|------|---------|
| Split Horizontal / Vertical | `split` / `vsplit` |
| Close Other / Equalize / Maximize | `only` / `<C-w>=` / `<C-w>_<C-w>\|` |
| Rotate Up / Down | `<C-w>R` / `<C-w>r` |

### Marks, Jumps, Spell, History, Options, Help

| Menu | Highlights |
|------|-----------|
| **Marks** | Set, view, clear marks |
| **Jumps** | Jump to last edit, last position |
| **Spell** | Toggle spell check, next/prev error, add/mark words |
| **History** | Command and search history |
| **Options** | Toggle line numbers, relative numbers, list chars, wrap, cursor line |
| **Help** | Vim help, version, view mappings and settings |

### Context Menu

LSP context menu (mapped to a key or callable from vimscript):

```
 Go to Definition
 Go to References
 Go to Implementation
 ─────────────────
 Hover
 Rename
 Code Action
 ─────────────────
 Format
```

---

## Plugins

### Configured in this distribution

| Plugin | Purpose |
|--------|---------|
| [guysoft/vim-quickui](https://github.com/guysoft/vim-quickui) | Menu bar and context menus (fork of skywind3000/vim-quickui) |
| [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs in gutter, inline blame, hunk operations |
| [NeogitOrg/neogit](https://github.com/NeogitOrg/neogit) | Magit-style git interface |
| [echasnovski/mini.map](https://github.com/echasnovski/mini.map) | Code minimap sidebar |
| [jedrzejboczar/possession.nvim](https://github.com/jedrzejboczar/possession.nvim) | Session management (auto-save per directory) |
| [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) | Code formatting |
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configuration |

### Dependencies (pulled automatically)

| Plugin | Required by |
|--------|-------------|
| [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | possession.nvim, neogit |
| [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim) | neogit |

### Provided by NvChad base

Telescope, Treesitter, nvim-cmp, Mason, nvim-tree, nvim-web-devicons, indent-blankline, and more. See the [NvChad docs](https://nvchad.com/) for the full list.

---

## Installation

### Prerequisites

- **Neovim** >= 0.9.0
- **Git** >= 2.19.0
- **Nerd Font** (optional, for icons)
- **C Compiler** (for treesitter)

### Install

1. Backup your current config:
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. Clone:
```bash
git clone https://github.com/guysoft/NvGuy.git ~/.config/nvim
```

3. Open Neovim and let it install plugins:
```bash
nvim
```

4. Install language servers:
```
:MasonInstallAll
```

---

## Key Bindings

### QuickUI

| Key | Action |
|-----|--------|
| `F10` or `<leader>m` | Open menu bar |
| `<leader>k` | Telescope keymaps (discover all bindings) |

### General

| Key | Action |
|-----|--------|
| `;` | Enter command mode |
| `jk` (insert mode) | Escape |

All other keybindings come from NvChad defaults. Press `<leader>k` or open **Tools > Keymaps** from the menu to browse them all.

---

## Customization

| What | Where |
|------|-------|
| Add plugins | `lua/plugins/init.lua` |
| Change keymaps | `lua/mappings.lua` |
| Change options | `lua/options.lua` |
| Configure LSP | `lua/configs/lspconfig.lua` |
| Edit menus | `plugin/quickui_config.vim` |
| QuickUI color scheme | `colors/quickui/crush.vim` |

See the customization guide at the bottom of `plugin/quickui_config.vim` for how to add your own menus.

---

## Troubleshooting

**Plugins won't install:**
```bash
rm -rf ~/.local/share/nvim/lazy
nvim
```

**LSP not working:**
```
:MasonInstallAll
```

**Treesitter errors:**
```
:TSUninstall all
:TSInstall all
```

**Cache issues:**
```bash
rm -rf ~/.cache/nvim
```

---

## AI-Driven Debugging (debug-reach)

NvGuy includes a **Run/Debug menu** and full nvim-dap integration that enables AI-driven debugging. An AI coding agent can programmatically set breakpoints, launch debug sessions, and step through code — all via nvim's RPC interface.

This feature requires all three repos working together:

| Component | Repo | Role |
|-----------|------|------|
| **NvGuy** | [guysoft/NvGuy](https://github.com/guysoft/NvGuy) | Wires up nvim-dap, dap-ui, mason-nvim-dap, and the Run menu |
| **vscodium.nvim** | [guysoft/vscodium.nvim](https://github.com/guysoft/vscodium.nvim) | Provides `debug-rpc.lua` module and the skill instructions |
| **tmux-ide** | [guysoft/tmux-ide](https://github.com/guysoft/tmux-ide) | Exposes `NVIM_IDE_SOCK` so agents can discover nvim's RPC socket |

The Run menu (accessible via F10 → Run) provides:
- Start/Stop Debugging
- Debug Last (re-run previous session)
- Toggle Breakpoint, Clear All Breakpoints
- Continue, Step Over, Step Into, Step Out
- Toggle Debug UI

---

## License

MIT License - see [LICENSE](LICENSE).

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes
4. Push and open a Pull Request

---

Made with ❤️ by [Guy Sheffer](https://github.com/guysoft)

Based on [NvChad](https://github.com/NvChad/NvChad)
