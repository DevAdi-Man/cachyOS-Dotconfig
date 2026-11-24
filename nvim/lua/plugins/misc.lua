-- Standalone plugins with less than 10 lines of config go here
return {
  {
    -- Tmux & split window navigation (Unix only)
    'christoomey/vim-tmux-navigator',
    enabled = vim.fn.has("win32") == 0,
  },
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },
  {
    -- Powerful Git integration for Vim
    'tpope/vim-fugitive',
  },
  {
    -- GitHub integration for vim-fugitive
    'tpope/vim-rhubarb',
  },
  {
    -- Hints keybinds
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      local wk = require('which-key')
      wk.setup()
      wk.add({ { '<leader>?', function() wk.show({ global = false }) end, desc = 'Show keymaps' } })
    end,
  },
  {
    -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {},
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    -- High-performance color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function()
      -- Update the installed colorizer's Ex command adapter for Neovim 0.12.
      getmetatable(require('colorizer/nvim').ex).__index = function(ex, key)
        local command = key:gsub('_$', '!')
        local run = function(...)
          vim.cmd(table.concat(vim.iter({ command, ... }):flatten(math.huge):totable(), ' '))
        end
        rawset(ex, key, run)
        return run
      end
      require('colorizer').setup()
    end,
  },
}
