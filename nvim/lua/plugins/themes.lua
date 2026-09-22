return {
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,

    config = function()
      local kanagawa = require 'kanagawa'

      kanagawa.setup {
        theme = 'lotus', -- options: wave | dragon | lotus
        transparent = true,
        background = {
          dark = 'wave',
          light = 'lotus',
        },
      }

      vim.cmd.colorscheme 'kanagawa'

      -- transparency toggle state
      local transparent = true

      local function toggle_transparency()
        transparent = not transparent
        kanagawa.setup {
          theme = 'wave',
          transparent = transparent,
        }
        vim.cmd.colorscheme 'kanagawa'
      end

      vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true, desc = 'Toggle transparency' })
    end,
  },
}
