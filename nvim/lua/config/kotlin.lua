-- Kotlin language server and Gradle shortcuts.
local M = {}

local gradle_build = { "build.gradle.kts", "build.gradle" }
local gradle_settings = { "settings.gradle.kts", "settings.gradle" }
local kotlin_roots = { gradle_settings, gradle_build, "pom.xml", "workspace.json" }

local function multiplatform_root(bufnr)
	local module = vim.fs.root(bufnr, gradle_build)
	if not module then
		return
	end

	local common = vim.uv.fs_stat(vim.fs.joinpath(module, "src", "commonMain"))
	local is_multiplatform = common and common.type == "directory"
	for _, name in ipairs(gradle_build) do
		local path = vim.fs.joinpath(module, name)
		if not is_multiplatform and vim.fn.filereadable(path) == 1 then
			local build = table.concat(vim.fn.readfile(path), "\n")
			is_multiplatform = build:find("org.jetbrains.kotlin.multiplatform", 1, true)
				or build:match([[kotlin%s*%(%s*["']multiplatform["']%s*%)]])
		end
	end
	if is_multiplatform then
		return vim.fs.root(bufnr, gradle_settings) or module
	end
end

function M.setup(capabilities)
	vim.api.nvim_create_user_command("KotlinLspInstall", function()
		vim.cmd.MasonInstall("kotlin-lsp")
	end, { desc = "Install JetBrains Kotlin LSP with Mason, then restart Neovim" })

	local has_kmp = vim.fn.executable("kmp-lsp") == 1
	local function kotlin_root(bufnr, on_dir)
		if not has_kmp or not multiplatform_root(bufnr) then
			on_dir(vim.fs.root(bufnr, kotlin_roots))
		end
	end
	if has_kmp then
		vim.lsp.config("kmp_lsp", {
			filetypes = { "kotlin" },
			root_dir = function(bufnr, on_dir)
				local root = multiplatform_root(bufnr)
				if root then
					on_dir(root)
				end
			end,
		})
		vim.lsp.enable("kmp_lsp")
	end

	-- Mason's kotlin-lsp package exposes the JetBrains launcher as intellij-server.
	if vim.fn.executable("intellij-server") == 1 then
		vim.lsp.config("kotlin_lsp", {
			capabilities = capabilities,
			root_dir = kotlin_root,
			settings = {
				kotlin = {
					inlayHints = { typeHints = true, parameterHints = true, chainedFunctionHints = true },
				},
			},
		})
		vim.lsp.enable("kotlin_lsp")
	elseif vim.fn.executable("kotlin-language-server") == 1 then
		-- Use the installed server until the JetBrains server is available.
		vim.lsp.config("kotlin_language_server", { capabilities = capabilities, root_dir = kotlin_root })
		vim.lsp.enable("kotlin_language_server")
	end

	-- ── Gradle runner (KMP/CMP friendly) — bottom terminal split ─────
	local function run_gradle(bufnr, term_cmd)
		local root = vim.fs.root(bufnr, "gradlew")
		if not root then
			vim.notify("Gradle wrapper not found for this buffer", vim.log.levels.WARN)
			return
		end

		local t = require("toggleterm.terminal").Terminal:new({
			cmd = term_cmd,
			dir = root,
			direction = "horizontal",
			size = 15,
			close_on_exit = false,
		})
		t:toggle()
	end

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("kotlin-gradle", { clear = true }),
		pattern = { "kotlin", "java" },
		callback = function(event)
			local opts = { buffer = event.buf }
			local gk = function(keys, cmd_str, desc)
				vim.keymap.set("n", keys, function()
					run_gradle(event.buf, cmd_str)
				end, vim.tbl_extend("force", opts, { desc = desc }))
			end
			gk("<leader>gb", "./gradlew :composeApp:assembleDebug", "Gradle: [B]uild debug (composeApp)")
			gk("<leader>gr", "./gradlew :composeApp:run", "Gradle: [R]un desktop app")
			gk("<leader>gk", "./gradlew :composeApp:compileKotlinMetadata", "Gradle: compile [K]MP metadata")
			gk("<leader>gg", "./gradlew build", "Gradle: [G]eneric build")
			gk("<leader>gw", "./gradlew ", "Gradle: open terminal, type task")
		end,
	})
end

return M
