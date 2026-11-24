local function node_lsp_command(server_name, fallback, ...)
	local args = { ... }
	return function(dispatchers, config)
		local server = vim.fn.executable(server_name) == 1 and server_name or fallback or server_name
		if config.root_dir then
			local project_server = vim.fs.joinpath(config.root_dir, "node_modules", ".bin", server_name)
			if vim.fn.executable(project_server) == 1 then
				server = project_server
			end
		end

		local command = { server, unpack(args) }
		if server == fallback then
			table.insert(command, 1, "node")
		end

		-- The current Node runtime needs ordinary pipes for LSP stdin and stdout.
		return vim.lsp.rpc.start({
			"bash", "-c", [[exec "$@" < <(cat) > >(cat)]], server_name, unpack(command),
		}, dispatchers)
	end
end

local function bundled_vscode_server(extension, script)
	local prefix = vim.fs.joinpath(vim.env.HOME, ".vscode", "extensions", extension .. "-")
	local latest_version, latest_server
	for _, dir in ipairs(vim.fn.glob(prefix .. "*", false, true)) do
		local version = vim.version.parse(dir:sub(#prefix + 1))
		local server = vim.fs.joinpath(dir, script)
		if version and vim.fn.filereadable(server) == 1 and (not latest_version or version > latest_version) then
			latest_version, latest_server = version, server
		end
	end
	return latest_server
end

local function sql_lsp_command(dispatchers)
	local server = vim.fn.exepath("sql-language-server")
	local compatibility = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "config", "sql-compat.cjs")
	return vim.lsp.rpc.start({
		"bash", "-c", [[exec "$@" < <(cat) > >(cat)]], "sqlls",
		"node", "--require", compatibility, server, "up", "--method", "stdio",
	}, dispatchers)
end

local function rust_analyzer_available()
	local analyzer = vim.uv.fs_realpath(vim.fn.exepath("rust-analyzer"))
	if not analyzer then
		return false
	end
	local rustup = vim.uv.fs_realpath(vim.fn.exepath("rustup"))
	-- A rustup shim can be on PATH even when the toolchain has no analyzer.
	return analyzer ~= rustup or vim.system({ "rustup", "which", "rust-analyzer" }):wait().code == 0
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "mason-org/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		-- mason-lspconfig:
		-- - Bridges the gap between LSP config names (e.g. "lua_ls") and actual Mason package names (e.g. "lua-language-server").
		-- - Used here only to allow specifying language servers by their LSP name (like "lua_ls") in `ensure_installed`.
		-- - It does not auto-configure servers — we use vim.lsp.config() + vim.lsp.enable() explicitly for full control.
		"mason-org/mason-lspconfig.nvim",
		-- mason-tool-installer:
		-- - Installs LSPs, linters, formatters, etc. by their Mason package name.
		-- - We use it to ensure all desired tools are present.
		-- - The `ensure_installed` list works with mason-lspconfig to resolve LSP names like "lua_ls".
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		{
			"j-hui/fidget.nvim",
			opts = {
				notification = {
					window = {
						winblend = 0, -- Background color opacity in the notification window
					},
				},
			},
		},

		-- Allows extra capabilities provided by nvim-cmp
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				-- Create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Jump to the definition of the word under your cursor.
				--  This is where a variable was first declared, or where a function is defined, etc.
				--  To jump back, press <C-t>.
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

				-- Find references for the word under your cursor.
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

				-- Jump to the implementation of the word under your cursor.
				--  Useful when your language has ways of declaring types without an actual implementation.
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

				-- Fuzzy find all the symbols in your current workspace.
				--  Similar to document symbols, except searches over your entire project.
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header.
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- LSP servers and clients are able to communicate to each other what features they support.
		-- By default, Neovim doesn't support everything that is in the LSP specification.
		-- When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		-- So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
		vim.lsp.config("*", { capabilities = capabilities })

		-- Enable the following language servers
		--
		-- Add any additional override configuration in the following tables. Available keys are:
		-- - cmd (table): Override the default command used to start the server
		-- - filetypes (table): Override the default list of associated filetypes for the server
		-- - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		-- - settings (table): Override the default settings passed when initializing the server.
		local svelte_fallback =
			bundled_vscode_server("svelte.svelte-vscode", "node_modules/svelte-language-server/bin/server.js")
		local eslint_fallback = bundled_vscode_server("dbaeumer.vscode-eslint", "server/out/eslintServer.js")
		local servers = {
			ts_ls = { cmd = node_lsp_command("typescript-language-server", nil, "--stdio") },
			svelte = { cmd = node_lsp_command("svelteserver", svelte_fallback, "--stdio") },
			eslint = { cmd = node_lsp_command("vscode-eslint-language-server", eslint_fallback, "--stdio") },
			clangd = {},
			rust_analyzer = {},
			ruff = {},
			pylsp = {
				settings = {
					pylsp = {
						plugins = {
							pyflakes = { enabled = false },
							pycodestyle = { enabled = false },
							autopep8 = { enabled = false },
							yapf = { enabled = false },
							mccabe = { enabled = false },
							pylsp_mypy = { enabled = false },
							pylsp_black = { enabled = false },
							pylsp_isort = { enabled = false },
						},
					},
				},
			},
			html = { filetypes = { "html", "twig", "hbs" } },
			cssls = {},
			tailwindcss = { cmd = node_lsp_command("tailwindcss-language-server", nil, "--stdio") },
			dockerls = {},
			sqlls = { cmd = sql_lsp_command },
			terraformls = {},
			jsonls = {},
			yamlls = {},
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						diagnostics = {
							globals = { "vim" },
							disable = { "missing-fields" },
						},
						format = {
							enable = false,
						},
					},
				},
			},
		}

		-- Ensure the servers and tools above are installed
		local has_rust_analyzer = rust_analyzer_available()
		local ensure_installed = vim.tbl_keys(servers)
		ensure_installed = vim.tbl_filter(function(server)
			return (server ~= "rust_analyzer" or not has_rust_analyzer)
				and (server ~= "svelte" or not svelte_fallback)
				and (server ~= "eslint" or not eslint_fallback)
		end, ensure_installed)
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
			"kotlin-lsp",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		for server, cfg in pairs(servers) do
			vim.lsp.config(server, cfg)
			-- Mason will enable rust_analyzer after a successful installation.
			if server ~= "rust_analyzer" or has_rust_analyzer then
				vim.lsp.enable(server)
			end
		end

		-- Kotlin / Android / Compose (KMP + CMP) LSP + Gradle runner setup
		require("config.kotlin").setup(capabilities)
	end,
}
