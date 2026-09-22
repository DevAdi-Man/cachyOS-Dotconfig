-- For conciseness
local opts = { noremap = true, silent = true }
-- Set leader Key
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Disable the spacebar key's default behavior in Normal and visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Disable arrow keys
vim.keymap.set({ 'n', 'v', 'i' }, '<Up>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v', 'i' }, '<Down>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v', 'i' }, '<Left>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v', 'i' }, '<Right>', '<Nop>', { silent = true })

-- Copy to system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Toggle neo tree
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', opts)
-- Toggle buffer list (floating window)
-- vim.keymap.set('n','<leader>b','<cmd>Neotree float toggle buffers<CR>',opts)
-- Git status (floating window)
vim.keymap.set('n', '<leader>gf', '<cmd>Neotree float git_status<CR>', opts)

-- Make file executable (Unix only)
if vim.fn.has 'win32' == 0 then
  vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })
end



-- Buffer
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>xb', ':Bdelete<CR>', opts) -- close current buffer (layout safe)

-- Yazi     Open yazi at the current file
vim.keymap.set({ 'n', 'v' }, '<leader>yf', '<cmd>Yazi<cr>', opts)
-- Open in the current working directory
vim.keymap.set({ 'n', 'v' }, '<leader>cf', '<cmd>Yazi cwd<cr>', opts)
-- Resume the last yazi session
vim.keymap.set({ 'n', 'v' }, '<leader>ct', '<cmd>Yazi toggle<cr>', opts)

vim.keymap.set({ 'n', 'v' }, 'H', '^', opts) -- start (non-blank)
vim.keymap.set({ 'n', 'v' }, 'L', '$', opts) -- end of line

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Vimium-style "F" mode: shows a letter hint on every visible window
-- (including floats like Godot docs/console), press the letter to jump there.
vim.keymap.set('n', '<leader>F', function()
	local ok, picker = pcall(require, 'window-picker')
	if not ok then
		vim.notify('window-picker not available', vim.log.levels.WARN)
		return
	end
	local picked = picker.pick_window({
		include_current_win = false,
		-- big floating letters (Vimium style); statusline hints get hidden
		-- behind lualine, so use float hints instead
		hint = 'floating-big-letter',
		-- override neo-tree's filters so ALL windows get hints (floats, console, docs, etc.)
		filter_rules = {
			autoselect_one = false,
			bo = { filetype = {}, buftype = {} },
			wo = {},
		},
	})
	if picked then
		vim.api.nvim_set_current_win(picked)
	end
end, { noremap = true, silent = true, desc = 'Vimium F: pick window by letter hint' })

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Scroll hover/float window
vim.keymap.set('n', '<C-f>', function()
  if not require('noice.lsp').scroll(4) then
    return '<C-f>'
  end
end, { silent = true, expr = true })
vim.keymap.set('n', '<C-b>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<C-b>'
  end
end, { silent = true, expr = true })

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Reload/refresh current file from disk (like VS Code's Revert File)
vim.keymap.set('n', '<leader>rf', ':e!<CR>', { desc = 'Reload current file from disk' })

-- Open nvim config from any where
vim.keymap.set('n', '<leader>ev', function()
  require('neo-tree.command').execute {
    dir = vim.fn.stdpath 'config',
    reveal = true,
  }
end, { desc = 'Open Neovim Config' })
