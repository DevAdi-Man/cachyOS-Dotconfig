return {
  {
    'rust-lang/rust.vim',
    ft = { 'rust' },
    cmd = { 'RustFmt', 'RustPlay', 'RustTest' },
    init = function()
      -- Auto-format on save (:RustFmt on save)
      vim.g.rustfmt_autosave = 1

      -- Playpen clipboard command (Wayland / X11)
      if vim.fn.executable 'wl-copy' == 1 then
        vim.g.rust_clip_command = 'wl-copy'
      else
        vim.g.rust_clip_command = 'xclip -selection clipboard'
      end
    end,
    config = function()
      -- Rust buffer-specific keymaps
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'rust',
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }
          vim.keymap.set('n', '<leader>rt', '<cmd>RustTest<cr>', vim.tbl_extend('force', opts, { desc = 'Rust: Run test under cursor' }))
        end,
      })
    end,
  },
}
