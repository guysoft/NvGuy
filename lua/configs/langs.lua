-- Language-specific LSP configs: Go and Python.
--
-- Each block is guarded by an executable check so this file is safe to ship
-- in NvGuy without forcing every user to install Go/Python tooling. On a
-- machine where the binary is missing the block simply does nothing.
--
-- Want support for another language? Open an issue at
-- https://github.com/guysoft/NvGuy/issues

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

--- Find a Python interpreter for the given workspace root.
--- Checks `.venv/bin/python` then `venv/bin/python`. Falls back to system python3.
---@param root string|nil
---@return string
local function detect_python(root)
  root = root or vim.fn.getcwd()
  local candidates = {
    root .. "/.venv/bin/python",
    root .. "/venv/bin/python",
  }
  for _, p in ipairs(candidates) do
    if vim.fn.executable(p) == 1 then
      return p
    end
  end
  return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python3"
end

-- ---------------------------------------------------------------------------
-- Go — gopls
-- ---------------------------------------------------------------------------
if vim.fn.executable("gopls") == 1 then
  vim.lsp.config("gopls", {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
        usePlaceholders = true,
        completeUnimported = true,
        analyses = {
          unusedparams = true,
          unusedwrite = true,
          nilness = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  })
  vim.lsp.enable("gopls")
end

-- ---------------------------------------------------------------------------
-- Python — basedpyright + ruff
-- ---------------------------------------------------------------------------
if vim.fn.executable("basedpyright-langserver") == 1 or vim.fn.executable("basedpyright") == 1 then
  vim.lsp.config("basedpyright", {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = {
      "pyproject.toml", "setup.py", "setup.cfg",
      "requirements.txt", "Pipfile", "pyrightconfig.json",
      ".venv", "venv", ".git",
    },
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "openFilesOnly",
          -- "standard" avoids flooding unfamiliar repos with warnings.
          -- Bump to "strict" per-project via pyrightconfig.json if desired.
          typeCheckingMode = "standard",
        },
      },
      python = {
        pythonPath = vim.fn.exepath("python3"),
      },
    },
    before_init = function(_, config)
      local root = config.root_dir or vim.fn.getcwd()
      local py = detect_python(root)
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = py
    end,
  })
  vim.lsp.enable("basedpyright")
end

if vim.fn.executable("ruff") == 1 then
  vim.lsp.config("ruff", {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = {
      "pyproject.toml", "ruff.toml", ".ruff.toml",
      "setup.py", "setup.cfg", "requirements.txt", ".git",
    },
    -- Defer hover to basedpyright; ruff hover is less useful.
    on_attach = function(client, _)
      client.server_capabilities.hoverProvider = false
    end,
  })
  vim.lsp.enable("ruff")
end
