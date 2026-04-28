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
    "NickvanDyke/opencode.nvim",
    lazy = false,
    dependencies = {
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      vim.g.opencode_opts = {}
      vim.o.autoread = true

      -- Create simple commands instead of keymaps
      vim.api.nvim_create_user_command('Opencode', function()
        require('opencode').toggle()
      end, { desc = 'Toggle opencode terminal' })

      vim.api.nvim_create_user_command('OpencodeAsk', function()
        require('opencode').ask('@this: ', { submit = true })
      end, { desc = 'Ask opencode about current selection/cursor' })

      vim.api.nvim_create_user_command('OpencodeSelect', function()
        require('opencode').select()
      end, { desc = 'Select opencode action' })

      vim.api.nvim_create_user_command('OpencodeAdd', function()
        require('opencode').prompt('@this')
      end, { desc = 'Add to opencode prompt' })
    end,
  },

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
  },  {
    "kevinhwang91/rnvimr",
    cmd = "RnvimrToggle",
    config = function()
      vim.g.rnvimr_draw_border = 1
      vim.g.rnvimr_pick_enable = 1
      vim.g.rnvimr_bw_enable = 1
      vim.g.rnvimr_ranger_cmd = { "ranger", "--cmd=set draw_borders both" }
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
}