---@diagnostic disable-next-line: undefined-global
local vim = vim
return {
  { -- git frontend in neovim
    'kjughx/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    config = function()
      require('neogit').setup {
        kind = 'tab',
        disable_context_highlighting = true,
        commit_commit = { verify_commit = false },
      }
      vim.keymap.set('n', '<leader>gg', '<cmd> Neogit<CR>', { desc = 'Open Neogit' })
    end,
  },

  {
    'saghen/blink.cmp',
    version = "v0.*",
    opts = {
      keymap = { preset = 'default' },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },

      signature = { enabled = true },

      completion = {
        list = {
          selection = {
            preselect = false,
          }
        },
      },
      sources = {
        default = { 'lsp', 'path', 'buffer', },
        cmdline = {},
      },
    },
  },

  {
    "ej-shafran/compile-mode.nvim",
    branch = "latest",
    dependecies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.g.compile_mode = {}
    end
  },
  {
    'nullromo/go-up.nvim',
    lazy = false,
    opts = {},   -- specify options here
  },

  'tpope/vim-sleuth',   -- Detect tabstop and shiftwidth automatically

  {                     -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { "<leader>g", group = "[G]it" },
        { "<leader>l", group = "[L]SP" },
        { "<leader>s", group = "[S]earch" },
      }
    end,
  },

  { import = 'lsp' },

  {
    'sainnhe/gruvbox-material',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.g.gruvbox_material_current_word = "underline"
      vim.g.gruvbox_material_diagnostic_text_highlight = true
      vim.g.gruvbox_material_enable_bold = true
      vim.g.gruvbox_material_better_performance = 2
      vim.g.gruvbox_material_dim_inactive_windows = true
      vim.g.gruvbox_material_transparent_background = true
      vim.g.gruvbox_material_background = 'soft'
      vim.cmd.colorscheme 'gruvbox-material'
      vim.cmd.hi 'Normal ctermfg=223 ctermbg=none gui=none guifg=none guibg=none'
    end,
  },


  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup(nil, { css = true, })
    end
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'
      statusline.section_location = function()
        return '%2l:%-2v'
      end
      statusline.section_fileinfo = function() end
      statusline.setup({ use_icons = vim.g.have_nerd_font })

      -- duh
      -- require 'mini.completion'.setup({})

      -- Show git diff in gutter
      require 'mini.diff'.setup({
        view = {
          style = 'sign',
          signs = { add = '+', change = '~', delete = '-' },
        },
        mappings = {
          apply = '<leader>gs',
          reset = '<leader>gr',
          goto_prev = "[c",
          goto_next = "]c"
        },
        options = {
          wrap_goto = true,
        }
      })

      -- require 'mini.pairs'.setup({})

      require 'mini.comment'.setup({
        mappings = {
          comment = '<leader>/',
          comment_line = '<leader>/',
          comment_visual = '<leader>/',
        }
      })
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  {
    'gelguy/wilder.nvim',
    dependencies = {
      'romgrk/fzy-lua-native'
    },
    config = function()
      local wilder = require('wilder')
      wilder.setup({ modes = { ':' } })

      wilder.set_option('pipeline', {
        wilder.branch(
          wilder.python_file_finder_pipeline({
            file_command = function(_, arg)
              if string.find(arg, "%.") ~= nil then
                return { 'fdfind', '-tf', '-H' }
              end
              return { 'fdfind', '-tf' }
            end,
            dir_command = { 'fdfind', '-td' },
          }),
          wilder.cmdline_pipeline({
            fuzzy = 2,
            fuzzy_filter = wilder.lua_fzy_filter(),
          }),
          {
            wilder.check(function(_, x) return x == '' end),
            wilder.history(),
          }
        ),
      })

      local highlighters = {
        wilder.pcre2_highlighter(),
        wilder.lua_fzy_highlighter(),
      }

      local popupmenu_renderer = wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme({
          highlighter = highlighters,
        })
      )

      wilder.set_option('renderer', wilder.renderer_mux({
        [':'] = popupmenu_renderer,
      }))
    end
  }
}
