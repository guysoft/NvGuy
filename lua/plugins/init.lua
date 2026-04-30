return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },

  {
    "jedrzejboczar/possession.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('possession').setup {
        commands = {
          save = 'SSave',
          load = 'SLoad',
          delete = 'SDelete',
          list = 'SList',
        },
        autosave = {
          current = true,
          cwd = true,
          tmp = false,
          on_load = true,
          on_quit = true,
        },
        autoload = 'auto_cwd',  -- Auto-load session when entering directory
      }
      
      -- Telescope integration
      local telescope_ok, telescope = pcall(require, 'telescope')
      if telescope_ok then
        telescope.load_extension('possession')
      end
    end,
  },



  {
    "guysoft/vim-quickui",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.quickui_show_tip = 1
      vim.g.quickui_border_style = 2
      vim.g.quickui_color_scheme = 'crush'
    end,
    config = function()
      local plugin_file = vim.fn.stdpath('data') .. '/lazy/vim-quickui/plugin/quickui.vim'
      vim.cmd('source ' .. plugin_file)

      -- Source crush color scheme from NvGuy config (in case the fork doesn't include it)
      local crush_file = vim.fn.stdpath('config') .. '/colors/quickui/crush.vim'
      if vim.fn.filereadable(crush_file) == 1 then
        vim.cmd('source ' .. crush_file)
      end

      vim.defer_fn(function()
        if vim.fn.exists('g:quickui_version') == 1 then
          vim.notify("vim-quickui plugin loaded v" .. vim.g.quickui_version, vim.log.levels.INFO)

          vim.defer_fn(function()
            pcall(vim.fn['quickui#menu#reset'])
            local config_file = vim.fn.stdpath('config') .. '/plugin/quickui_config.vim'
            vim.cmd('source ' .. config_file)
          end, 100)
        else
          vim.notify("vim-quickui plugin file loaded but version not set", vim.log.levels.ERROR)
        end
      end, 50)
    end,
  },

  {
    "echasnovski/mini.map",
    version = false,
    lazy = false,
    config = function()
      local map = require "mini.map"
      map.setup {
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic(),
        },
        window = {
          width = 10,
          winblend = 50,
        },
      }
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          pcall(map.open)
        end,
      })
    end,
  },

  -- Gitsigns (git integration in buffer - like GitLens)
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        current_line_blame = false, -- Toggle with :Gitsigns toggle_current_line_blame
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 500,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map('n', ']c', gs.next_hunk, { desc = "Next hunk" })
          map('n', '[c', gs.prev_hunk, { desc = "Prev hunk" })
          map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage hunk" })
          map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset hunk" })
          map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage buffer" })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Undo stage" })
          map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset buffer" })
          map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview hunk" })
          map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = "Blame line (full)" })
          map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "Toggle line blame" })
          map('n', '<leader>hd', gs.diffthis, { desc = "Diff this" })
          map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff this ~" })
        end
      })
    end,
  },

  -- Neogit (magit-style git interface)
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    config = function()
      require("neogit").setup({
        integrations = {
          diffview = true
        },
        signs = {
          section = { ">", "v" },
          item = { ">", "v" },
          hunk = { "", "" },
        },
      })
    end,
  },

  -- Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    lazy = false,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "debugpy", "delve" },
      })
    end,
  },

  -- vscodium.nvim - VSCode-like Run/Debug
  {
    dir = "/Users/guyshe/workspace/ai/vscodium.nvim",
    lazy = false,
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
    config = function()
      require("nvim-launch").setup({
        tmux_pane = 1,
        tmux_clear = true,
        keymaps = true,
      })
    end,
  },
}