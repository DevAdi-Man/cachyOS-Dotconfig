local function enable_completion()
  vim.opt_local.completefunc = "v:lua.require'config.mongodb'.complete"
end

return {
  "gh-liu/vim-dbcp",
  dependencies = { "tpope/vim-dadbod" },
  cmd = { "MongoCompletion" },
  event = { "BufReadPre *.mongo.js,*.mongodb.js", "BufNewFile *.mongo.js,*.mongodb.js" },
  config = function()
    vim.api.nvim_create_user_command("MongoCompletion", enable_completion, {
      desc = "Enable MongoDB completion in this buffer (Ctrl-X Ctrl-U)",
    })
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
      group = vim.api.nvim_create_augroup("MongoCompletion", { clear = true }),
      pattern = { "*.mongo.js", "*.mongodb.js" },
      callback = enable_completion,
    })
  end,
}
