-- Kotlin / Android / Compose (KMP + CMP) LSP setup
-- Called from lua/plugins/lsp.lua (inside the nvim-lspconfig config function)
local M = {}

function M.setup()
	local data_dir = vim.fn.stdpath("data") -- ~/.local/share/nvim
	-- Find installed intellij-server binary (kotlin-server-<ver>/bin/intellij-server)
	local server_bin = vim.fn.glob(data_dir .. "/kotlin-server-*/bin/intellij-server", false, true)[1]
	local lsp_root = data_dir .. "/kotlin-lsp"

	-- ── One-time installer ────────────────────────────────────────────
	-- Run `:KotlinLspInstall` once. Downloads the official JetBrains
	-- Kotlin LSP (kotlin-server) into `data_dir`. URL pattern taken from
	-- the mason-registry `kotlin-lsp` package definition.
	local function install_kotlin_lsp()
		local ok, out = pcall(function()
			return vim.fn.system({
				"curl",
				"-sL",
				"https://api.github.com/repos/Kotlin/kotlin-lsp/releases/latest",
			})
		end)
		if not ok or vim.v.shell_error ~= 0 then
			vim.notify("KotlinLspInstall: failed to query GitHub releases", vim.log.levels.ERROR)
			return
		end
		local tag = out:match('"tag_name"%s*:%s*"kotlin%-lsp/v([^"]+)"') or out:match('"tag_name"%s*:%s*"([^"]+)"')
		if not tag then
			vim.notify("KotlinLspInstall: could not parse latest release tag", vim.log.levels.ERROR)
			return
		end
		local url = string.format(
			"https://download-cdn.jetbrains.com/language-server/kotlin-server/%s/kotlin-server-%s.tar.gz",
			tag,
			tag
		)
		local archive = lsp_root .. ".tar.gz"
		vim.fn.mkdir(data_dir, "p")
		vim.notify("KotlinLspInstall: downloading " .. url, vim.log.levels.INFO)
		vim.fn.system({ "curl", "-sL", "-o", archive, url })
		if vim.v.shell_error ~= 0 then
			vim.notify("KotlinLspInstall: download failed: " .. url, vim.log.levels.ERROR)
			return
		end
		vim.fn.system({ "tar", "-xzf", archive, "-C", data_dir })
		os.remove(archive)
		local bin = data_dir .. "/kotlin-server-" .. tag .. "/bin/intellij-server"
		if vim.fn.filereadable(bin) == 1 then
			os.execute("chmod +x " .. bin)
			-- store version for reference
			local fh = io.open(lsp_root .. "/VERSION", "w")
			if fh then
				fh:write(tag)
				fh:close()
			end
			vim.notify("Kotlin LSP installed: " .. bin .. " (restart nvim)", vim.log.levels.INFO)
		else
			vim.notify("KotlinLspInstall: intellij-server not found after extract", vim.log.levels.ERROR)
		end
	end

	vim.api.nvim_create_user_command("KotlinLspInstall", install_kotlin_lsp, {})

	-- ── Server command resolution ─────────────────────────────────────
	local cmd
	if vim.fn.filereadable(server_bin) == 1 then
		-- Official JetBrains Kotlin LSP (intellij-server)
		cmd = { server_bin, "--stdio" }
	else
		-- Fallback to mason's intellij-server / kotlin-lsp if installed there
		local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/intellij-server"
		local mason_kls = vim.fn.stdpath("data") .. "/mason/bin/kotlin-lsp"
		if vim.fn.filereadable(mason_bin) == 1 then
			cmd = { mason_bin, "--stdio" }
		elseif vim.fn.filereadable(mason_kls) == 1 then
			cmd = { mason_kls, "--stdio" }
		end
	end

	if not cmd then
		vim.notify_once(
			"Kotlin LSP not found. Run :KotlinLspInstall (or :MasonInstall kotlin-lsp).",
			vim.log.levels.WARN
		)
		return
	end

	local capabilities = vim.tbl_deep_extend(
		"force",
		vim.lsp.protocol.make_client_capabilities(),
		require("cmp_nvim_lsp").default_capabilities()
	)

	-- LSP attach keymaps (same conventions as the rest of this config)
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("kotlin-lsp-attach", { clear = true }),
		callback = function(event)
			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "Kotlin LSP: " .. desc })
			end
			map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
			map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
			map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
			map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
			map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
			map("K", vim.lsp.buf.hover, "Hover Documentation")
		end,
	})

	vim.lsp.config("kotlin_lsp", {
		cmd = cmd,
		filetypes = { "kotlin" },
		root_markers = { "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts" },
		capabilities = capabilities,
		settings = {
			kotlin = {
				inlayHints = { typeHints = true, parameterHints = true, chainedFunctionHints = true },
			},
		},
	})
	vim.lsp.enable("kotlin_lsp")

	-- ── Gradle runner (KMP/CMP friendly) — bottom terminal split ─────
	local function run_gradle(term_cmd)
		local t = require("toggleterm").new({
			cmd = term_cmd,
			dir = "git",
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
					run_gradle(cmd_str)
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
