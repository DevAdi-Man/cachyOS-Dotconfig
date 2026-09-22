return {
  "stevearc/conform.nvim",

  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        -- stop_after_first => first available formatter is used (biome fallback to prettier)
        -- biome-check = format + import sorting + safe lint fixes
        javascript = { "biome-check", "prettier", stop_after_first = true },
        typescript = { "biome-check", "prettier", stop_after_first = true },
        json = { "biome-check", "prettier", stop_after_first = true },
      },

      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    })

    -- keymap
    vim.keymap.set("n", "<leader>f", function()
      conform.format({ async = true, lsp_fallback = true })
    end, { desc = "Format file" })
  end,
}
