require("nvchad.configs.lspconfig").defaults()

-- read :h vim.lsp.config for changing options of lsp servers

local servers = { "html", "cssls" }
vim.lsp.enable(servers)

-- Language-specific LSP configs (Go, Python, …) live in langs.lua.
-- Each block is guarded by an executable check — safe on machines that don't
-- have those toolchains installed.
require "configs.langs"

