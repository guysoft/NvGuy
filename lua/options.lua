require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- Workaround: nvim 0.12.x markdown treesitter parser crashes on range() call.
-- Only apply on affected versions. See MARKDOWN_FIX.md for details.
-- Upstream: https://github.com/neovim/neovim/issues/39032
if vim.fn.has("nvim-0.12") == 1 and vim.fn.has("nvim-0.13") == 0 then
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
end
