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
          -- version loaded silently; use :echo g:quickui_version to check

          vim.defer_fn(function()
            pcall(vim.fn['quickui#menu#reset'])
            -- The config file has a load guard (g:quickui_config_loaded) to prevent
            -- double-sourcing on startup. We need to unset it here because this
            -- deferred re-source is intentional: it rebuilds the menus after
            -- quickui#menu#reset() so leader+m works correctly.
            vim.g.quickui_config_loaded = nil
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
      -- Skip mini.map on filetypes that render inline images — the minimap's
      -- floating window overlaps with image.nvim's placements and causes
      -- continuous redraw/flicker. Markdown/quarto/norg are image-heavy.
      local image_filetypes = {
        markdown = true, quarto = true, vimwiki = true, norg = true,
      }
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(ev)
          local ft = vim.bo[ev.buf].filetype
          if image_filetypes[ft] then
            pcall(map.close)
            return
          end
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

  -- gitui.nvim (gitui TUI in a floating window)
  {
    "aspeddro/gitui.nvim",
    lazy = true,
    cmd = "Gitui",
    config = function()
      require("gitui").setup({
        binary = "gitui",
        args = {},
        window = {
          options = {
            width = 90,
            height = 80,
            border = "rounded",
          },
        },
      })
    end,
  },

  -- Rich text rendering for markdown buffers: heading bars + icons, code
  -- block backgrounds, bullet glyphs, table borders, checkboxes, callouts.
  -- This is what makes nvim feel "GitHub-preview" in combination with
  -- image.nvim below.
  -- Requires: tree-sitter parsers for markdown + markdown_inline + html
  -- (mason / TSInstall handles them).
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "quarto", "norg" },
    opts = {
      file_types = { "markdown", "quarto" },
      heading = {
        sign = true,
        position = "overlay",
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "block",
        left_pad = 1,
        right_pad = 4,
      },
      code = {
        style = "full",
        border = "thick",
        language_pad = 2,
        position = "left",
        width = "block",
        right_pad = 4,
      },
      bullet = { right_pad = 1 },
      checkbox = {
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰄵 " },
      },
      pipe_table = { style = "full" },
      link = {
        enabled = true,
        image = "󰥶 ",
        hyperlink = "󰌹 ",
      },
      quote = { repeat_linebreak = true },
    },
  },

  -- Inline images in Markdown via the Kitty Graphics Protocol.
  -- Pinned to Unicode-placeholders mode so scrolling/splits/floats stay
  -- sane (the default direct-placement mode has the well-known glitches).
  -- Requires:
  --   * kitty terminal (or Ghostty)
  --   * ImageMagick on PATH (`brew install imagemagick`)
  --   * tmux: `set -g allow-passthrough on` in ~/.tmux.conf
  {
    "3rd/image.nvim",
    build = false, -- skip the luarocks build; we use magick_cli
    ft = { "markdown", "quarto", "norg" },
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      kitty_method = "unicode-placeholders",
      -- Smaller footprint so the virt_lines reservation matches the painted
      -- image more closely, and so we don't fight Claude Code in the top pane.
      max_width_window_percentage = 60,
      max_height_window_percentage = 25,
      -- Hide images when the nvim pane isn't focused (we're in a tmux split).
      editor_only_render_when_focused = true,
      tmux_show_only_in_active_window = true,
      window_overlap_clear_enabled = true,
      -- mini.map's minimap window is in the ignore list as belt+braces; the
      -- BufEnter hook in mini.map's spec also closes it on markdown buffers.
      window_overlap_clear_ft_ignore = {
        "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign",
        "minimap", "MiniMap",
      },
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,          -- keep images visible while editing
          download_remote_images = true,
          only_render_image_at_cursor = false,   -- render ALL images at once (GitHub-preview vibe)
          filetypes = { "markdown", "vimwiki", "quarto" },
        },
        neorg = { enabled = true, filetypes = { "norg" } },
        html = { enabled = false },
        css = { enabled = false },
      },
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    },
  },

  -- Smooth scrolling for <C-d>, <C-u>, <C-f>, <C-b>, zz, etc.
  {
    "psliwka/vim-smoothie",
    event = "VeryLazy",
    config = function()
      vim.g.smoothie_speed_constant_factor = 10
      vim.g.smoothie_speed_linear_factor   = 13
      vim.keymap.set({ "n", "v" }, "<ScrollWheelDown>",
        [[<cmd>call smoothie#do("\<lt>C-E>")<CR>]],
        { silent = true, desc = "Smooth scroll down (wheel)" })
      vim.keymap.set({ "n", "v" }, "<ScrollWheelUp>",
        [[<cmd>call smoothie#do("\<lt>C-Y>")<CR>]],
        { silent = true, desc = "Smooth scroll up (wheel)" })
    end,
  },

  -- Debug stack (nvim-dap + dap-ui + dap-python + virtual-text + vscodium.nvim
  -- + mason-tool-installer for debugpy) lives in plugins/debug.lua so it can
  -- be loaded with `{ import = "plugins.debug" }` from init.lua.
}