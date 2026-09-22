return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('gitsigns').setup {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      signs_staged = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = true, -- VSCode-style inline blame
      current_line_blame_opts = {
        delay = 500,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local opts = { buffer = bufnr, silent = true }

        -- ── Hunk navigation ─────────────────────────────────────────
        vim.keymap.set('n', ']c', gs.next_hunk, vim.tbl_extend('force', opts, { desc = 'Next hunk' }))
        vim.keymap.set('n', '[c', gs.prev_hunk, vim.tbl_extend('force', opts, { desc = 'Prev hunk' }))

        -- ── Hunk actions ────────────────────────────────────────────
        vim.keymap.set('n', '<leader>hs', gs.stage_hunk, vim.tbl_extend('force', opts, { desc = 'Stage hunk' }))
        vim.keymap.set('n', '<leader>hr', gs.reset_hunk, vim.tbl_extend('force', opts, { desc = 'Reset hunk' }))
        vim.keymap.set('n', '<leader>hp', gs.preview_hunk, vim.tbl_extend('force', opts, { desc = 'Preview hunk' }))
        vim.keymap.set('n', '<leader>hd', gs.diffthis, vim.tbl_extend('force', opts, { desc = 'Diff this hunk' }))

        -- ── Visual mode stage/reset ──────────────────────────────────
        vim.keymap.set('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, vim.tbl_extend('force', opts, { desc = 'Stage selected hunks' }))
        vim.keymap.set('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, vim.tbl_extend('force', opts, { desc = 'Reset selected hunks' }))

        -- ── Blame ────────────────────────────────────────────────────
        -- Quick popup blame (gitsigns) — <leader>hb
        -- Full tab blame with history (git.nvim) — <leader>gb
        vim.keymap.set('n', '<leader>hb', function()
          gs.blame_line { full = true }
        end, vim.tbl_extend('force', opts, { desc = 'Blame line (popup)' }))

        -- ── Buffer-level actions ─────────────────────────────────────
        vim.keymap.set('n', '<leader>hS', gs.stage_buffer, vim.tbl_extend('force', opts, { desc = 'Stage buffer' }))
        vim.keymap.set('n', '<leader>hR', gs.reset_buffer, vim.tbl_extend('force', opts, { desc = 'Reset buffer' }))
        vim.keymap.set('n', '<leader>hU', gs.reset_buffer_index, vim.tbl_extend('force', opts, { desc = 'Unstage buffer' }))

        -- ── Toggle inline blame visibility ───────────────────────────
        vim.keymap.set('n', '<leader>hT', gs.toggle_current_line_blame, vim.tbl_extend('force', opts, { desc = 'Toggle inline blame' }))
      end,
    }
  end,
}
