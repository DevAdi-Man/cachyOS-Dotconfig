return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		-- In nvim-treesitter v1, highlight/indent are enabled by default.
		-- setup() only accepts install_dir.
		require("nvim-treesitter").setup()

		-- Install parsers
		local parsers = {
			"lua", "python", "javascript", "typescript", "tsx",
			"html", "css", "json", "regex", "bash",
			"vim", "vimdoc",
			"go", "rust", "c", "cpp",
			"java", "kotlin", "groovy", "scala",
			"properties", "xml", "make", "cmake",
			"dockerfile", "terraform", "yaml", "toml",
			"graphql", "sql", "gitignore",
			"gdscript", "gdshader", -- Godot 4 (used by godotdev.nvim)
			"markdown", "markdown_inline",
		}
		require("nvim-treesitter.install").install(parsers)
	end,
}
