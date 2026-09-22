return {
	"tpope/vim-fugitive",
	cmd = { "Git", "G" },

	keys = {
		{ "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
		{ "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff split" },
		{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
		{ "<leader>gl", "<cmd>Git log<cr>", desc = "Git log" },

		{ "<leader>ga", "<cmd>Git add .<cr>", desc = "Git add all" },
		{ "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit", nowait = true },
		{ "<leader>gca", "<cmd>Git commit --amend<cr>", desc = "Edit last commit message" },
		{ "<leader>gcf", "<cmd>Git commit --amend --no-edit<cr>", desc = "Fix last commit (no message change)" },

		-- inline commit: stage all + open commit buffer in one step
		{ "<leader>gC", "<cmd>Git add . | Git commit<cr>", desc = "Git add all + commit" },

		{ "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
		{ "<leader>gP", "<cmd>Git pull<cr>", desc = "Git pull" },
	},

	config = function()
		local map = vim.keymap.set

		-- diff navigation (like VSCode resolve conflicts)
		map("n", "gu", "<cmd>diffget //2<cr>")
		map("n", "gh", "<cmd>diffget //3<cr>")

		-- fugitive buffer specific keymaps
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "fugitive",
			callback = function(event)
				local opts = { buffer = event.buf, silent = true }

				-- push
				map("n", "<leader>p", "<cmd>Git push<cr>", opts)

				-- pull with rebase
				map("n", "<leader>r", "<cmd>Git pull --rebase<cr>", opts)

				-- push upstream
				map("n", "<leader>t", ":Git push -u origin ", opts)
			end,
		})
	end,
}
