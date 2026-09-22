return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    direction = 'float',
  },
  keys = {
    { '<leader>tt', '<cmd>ToggleTerm<CR>', desc = 'Toggle Terminal', mode = { 'n' } },
    { '<leader>tt', '<cmd>ToggleTerm<CR>', desc = 'Toggle Terminal', mode = { 't' } },
  },
}
