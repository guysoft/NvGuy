-- NvGuy debug module: ships nvim-dap + UI + Python adapter + vscodium.nvim's
-- nvim-launch.debug-rpc, plus a mason-tool-installer entry that auto-installs
-- debugpy. Together these let `guyide debug ...` (and humans) drive a real
-- debug session out of the box.
--
-- Lazy strategy: most pieces lazy-load on the dap commands/keymaps a user
-- would invoke, but vscodium.nvim is loaded eagerly because the guyide CLI
-- expects `require("nvim-launch.debug-rpc")` to be available without a
-- prior dap action.

return {
  -- Core dap engine.
  {
    "mfussenegger/nvim-dap",
    cmd = {
      "DapContinue", "DapToggleBreakpoint", "DapStepOver", "DapStepInto",
      "DapStepOut", "DapTerminate", "DapRestartFrame",
    },
    keys = {
      { "<leader>dc", function() require("dap").continue() end,          desc = "DAP continue" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
      { "<leader>do", function() require("dap").step_over() end,         desc = "DAP step over" },
      { "<leader>di", function() require("dap").step_into() end,         desc = "DAP step into" },
      { "<leader>du", function() require("dap").step_out() end,          desc = "DAP step out" },
      { "<leader>dx", function() require("dap").terminate() end,         desc = "DAP terminate" },
    },
  },

  -- UI panels for humans (scopes, breakpoints, stack frames).
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI toggle" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]    = function() dapui.close() end
    end,
  },

  -- Inline value display while stopped.
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = { commented = true },
  },

  -- Python adapter glue (debugpy).
  --
  -- Resolution order:
  --   1. $NVGUY_DEBUGPY_PYTHON if set and executable (e2e + advanced users).
  --   2. Mason's debugpy venv if mason has installed it.
  --   3. python3 on PATH (assumes user has pip-installed debugpy globally).
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "python",
    config = function()
      local override = vim.env.NVGUY_DEBUGPY_PYTHON
      if override and override ~= "" and vim.fn.executable(override) == 1 then
        require("dap-python").setup(override)
        return
      end
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      if vim.fn.executable(mason_path) == 1 then
        require("dap-python").setup(mason_path)
      else
        require("dap-python").setup("python3")
      end
    end,
  },

  -- nvim-launch + debug-rpc: the IPC layer guyide drives. Loaded eagerly
  -- because guyide may call require("nvim-launch.debug-rpc") at any time.
  --
  -- Set NVGUY_VSCODIUM_LOCAL=/path/to/checkout to point lazy at a local
  -- working copy instead of cloning from GitHub. Useful for guyide e2e
  -- tests and when iterating on unpublished vscodium.nvim changes.
  (function()
    local local_path = vim.env.NVGUY_VSCODIUM_LOCAL
    local config_fn = function()
      -- nvim-launch.setup powers the quickui Run/Debug menu integration that
      -- humans see (tmux pane wiring, keymaps). The debug-rpc submodule that
      -- guyide drives loads regardless of this call.
      local ok, nl = pcall(require, "nvim-launch")
      if ok and type(nl.setup) == "function" then
        nl.setup({
          tmux_pane = 1,
          tmux_clear = true,
          keymaps = true,
        })
      end
    end
    if local_path and local_path ~= "" then
      return {
        name = "vscodium.nvim",
        dir = local_path,
        lazy = false,
        priority = 800,
        dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
        config = config_fn,
      }
    end
    return {
      "guysoft/vscodium.nvim",
      lazy = false,
      priority = 800,
      dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
      config = config_fn,
    }
  end)(),

  -- Auto-install debugpy via mason on startup. mason.nvim ships with NvChad.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = { "debugpy" },
      run_on_start = true,
      auto_update = false,
    },
  },
}
