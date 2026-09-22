return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  opts = {
    lsp = {
      -- override markdown rendering so that cmp and other plugins use Treesitter
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    -- scroll hover float with <C-f> and <C-b>
    views = {
      hover = {
        scrollbar = true,
      },
    },
    presets = {
      bottom_search = true,        -- classic search bar at bottom
      command_palette = true,      -- position cmdline and popupmenu together
      long_message_to_split = true, -- long messages go to split
      lsp_doc_border = true,       -- border around hover docs
    },
    -- Let fugitive's Git commit open its buffer editor normally
    routes = {
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'waiting for your editor',
        },
        opts = { skip = true },
      },
    },
  },
  keys = {
    { '<C-f>', function() if not require('noice.lsp').scroll(4)  then return '<C-f>' end end, silent = true, expr = true, desc = 'Scroll float down' },
    { '<C-b>', function() if not require('noice.lsp').scroll(-4) then return '<C-b>' end end, silent = true, expr = true, desc = 'Scroll float up' },
  },
}
