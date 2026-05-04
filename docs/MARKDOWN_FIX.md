# Markdown Treesitter Crash Fix (nvim 0.12.x)

## The Bug

Neovim 0.12.1 and 0.12.2 crash when opening any markdown file that contains
fenced code blocks (triple backticks). The error:

```
Decoration provider "start" (ns=nvim.treesitter.highlighter):
Lua: .../vim/treesitter/languagetree.lua:215: .../vim/treesitter.lua:196: attempt to call method 'range' (a nil value)
```

**Upstream issue:** https://github.com/neovim/neovim/issues/39032
Closed as "Not planned", pushed to backlog.

## Root Cause

The bundled markdown treesitter query uses `(#set! conceal_lines "")` on
`fenced_code_block_delimiter` nodes. This predicate internally calls `.range()`
on a node that is nil in 0.12.x.

The bundled `ftplugin/markdown.lua` calls `vim.treesitter.start()` on every
markdown buffer, which triggers the crash before any user config can intervene.

## The Fix

In `lua/options.lua`, monkey-patch `vim.treesitter.start()` to skip markdown
buffers and fall back to legacy vim syntax highlighting:

```lua
local orig_ts_start = vim.treesitter.start
vim.treesitter.start = function(bufnr, lang, ...)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  lang = lang or vim.bo[bufnr].filetype
  if lang == "markdown" then
    vim.bo[bufnr].syntax = "markdown"
    return
  end
  return orig_ts_start(bufnr, lang, ...)
end
```

This intercepts the call from the bundled ftplugin before it reaches the broken
parser. All other languages continue to use treesitter normally.

## What Doesn't Work

- `after/ftplugin/markdown.lua` with `vim.treesitter.stop()` — too late, the
  bundled ftplugin already called `vim.treesitter.start()` and the crash fires
  during the first redraw.
- `ftplugin/markdown.lua` with `vim.b.did_ftplugin = 1` — nvim's bundled
  markdown ftplugin doesn't check this variable.
- `FileType` autocmd — fires at the same time as the ftplugin, no guaranteed
  ordering.
- Deleting the nvim-treesitter compiled parser `.so` — the bundled parser at
  `/opt/homebrew/Cellar/neovim/X.Y.Z/lib/nvim/parser/markdown.so` has the
  same bug.
- Reinstalling via `:TSInstall markdown markdown_inline` — the recompiled
  parser still triggers the same query bug.

## When to Remove

Remove the monkey-patch once neovim ships a version where the markdown
treesitter query no longer crashes. Test by opening a markdown file with
fenced code blocks and confirming no error appears.

Check the upstream issue for status: https://github.com/neovim/neovim/issues/39032
