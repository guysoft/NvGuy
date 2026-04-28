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
    "skywind3000/vim-quickui",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.quickui_show_tip = 1
      vim.g.quickui_border_style = 2
      vim.g.quickui_color_scheme = 'crush'
      
      -- Apply Crush theme colors
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          -- Menu colors
          vim.api.nvim_set_hl(0, 'QuickUiMenu', { bg = '#2d2c35', fg = '#DFDBDD' })
          vim.api.nvim_set_hl(0, 'QuickUiSelect', { bg = '#6B50FF', fg = '#F1EFEF', bold = true })
          vim.api.nvim_set_hl(0, 'QuickUiTips', { bg = '#201F26', fg = '#858392' })
          vim.api.nvim_set_hl(0, 'QuickUiBorder', { bg = '#2d2c35', fg = '#3A3943' })
          vim.api.nvim_set_hl(0, 'QuickUiText', { bg = '#2d2c35', fg = '#BFBCC8' })
        end,
      })
      
      -- Trigger immediately for current colorscheme
      vim.api.nvim_exec_autocmds("ColorScheme", {})
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
}
