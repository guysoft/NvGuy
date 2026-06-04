local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- Go: gofumpt + goimports — only active when the binaries are on PATH.
    go = (vim.fn.executable("gofumpt") == 1 or vim.fn.executable("goimports") == 1)
      and { "gofumpt", "goimports" } or nil,
    -- Python: ruff import-sort then format — only active when ruff is on PATH.
    python = vim.fn.executable("ruff") == 1
      and { "ruff_organize_imports", "ruff_format" } or nil,
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
