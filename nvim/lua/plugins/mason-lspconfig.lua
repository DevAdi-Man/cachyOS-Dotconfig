return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-lspconfig").setup({
      automatic_enable = { exclude = { "kotlin_lsp", "kotlin_language_server" } },
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "pyright",
      },
    })
  end,
}
