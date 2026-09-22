return {
	--========================================================================
	-- Kotlin / Android / Compose (KMP + CMP) development setup
	--========================================================================
	-- LSP  : JetBrains official Kotlin LSP (LSP 3.17, best Compose + KMP support)
	-- DAP  : nvim-dap + Kotlin Debug Adapter (breakpoints in .kt / Compose code)
	-- Misc : droid-nvim (adb / emulator / logcat / gradle)
	--========================================================================

	----------------------------------------------------------------------------
	-- 1) nvim-dap + Kotlin Debug Adapter
	----------------------------------------------------------------------------
	{
		"mfussenegger/nvim-dap",
		ft = { "kotlin", "java" },
		dependencies = {
			-- Kotlin Debug Adapter (installed via mason: `:MasonInstall kotlin-debug-adapter`)
			"mason-org/mason.nvim",
		},
		config = function()
			local dap = require("dap")

			dap.adapters.kotlin = {
				type = "executable",
				command = "kotlin-debug-adapter",
				options = { auto_continue_if_many_stopped = false },
			}

			dap.configurations.kotlin = {
				{
					type = "kotlin",
					request = "launch",
					name = "This file",
					mainClass = function()
						-- Infer fully-qualified main class from the file path
						local path = vim.fn.expand("%:p:h")
						local root = vim.fn.getcwd()
						local pkg = path:gsub(root, ""):gsub("src/[a-zA-Z]*/kotlin/", ""):gsub("/", ".")
						local name = vim.fn.expand("%:t:r")
						local module = path:match("/([^/]+)/src/")
						if module then
							return ":" .. module .. ":main --mainClass " .. pkg .. "." .. name
						end
						return "--mainClass " .. pkg .. "." .. name
					end,
					projectRoot = "${workspaceFolder}",
					json = { swank = true },
				},
			}

			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle [B]reakpoint" })
			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: [C]ontinue" })
			vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP: Step [O]ver" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP: Step [I]nto" })
			vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "DAP: [Q]uit debugger" })
		end,
	},

	----------------------------------------------------------------------------
	-- 2) droid-nvim — adb devices, emulator, logcat, gradle tasks
	----------------------------------------------------------------------------
	{
		"rizukirr/droid-nvim",
		ft = { "kotlin", "java" },
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local droid = require("droid")


			vim.keymap.set("n", "<leader>agt", function()
				droid.gradle_tasks()
			end, { desc = "Android: Gradle [T]asks" })

			vim.keymap.set("n", "<leader>add", function()
				droid.devices()
			end, { desc = "Android: [D]evices" })

			vim.keymap.set("n", "<leader>al", function()
				droid.logcat()
			end, { desc = "Android: [L]ogcat" })

			vim.keymap.set("n", "<leader>ai", function()
				droid.install_apk()
			end, { desc = "Android: [I]nstall apk" })
		end,
	},
	----------------------------------------------------------------------------
	-- 3) Kotlin LSP (JetBrains official) — core LSP setup + Gradle runner
	----------------------------------------------------------------------------
	{
		"neovim/nvim-lspconfig",
		ft = { "kotlin", "java" },
		cmd = { "KotlinLspInstall" },
		config = function()
			local data_dir = vim.fn.stdpath("data") -- ~/.local/share/nvim
			local lsp_root = data_dir .. "/kotlin-lsp"
			local server_bin = lsp_root .. "/kotlin-lsp.sh"

			-- ── One-time installer ────────────────────────────────────────────
			-- Run `:KotlinLspInstall` once. Downloads the latest official
			-- JetBrains Kotlin LSP from GitHub releases into `data_dir`.
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
				local tag = out:match('"tag_name"%s*:%s*"([^"]+)"')
				if not tag then
					vim.notify("KotlinLspInstall: could not parse latest release tag", vim.log.levels.ERROR)
					return
				end
				local url = string.format(
					"https://download-cdn.jetbrains.com/kotlin-lsp/%s/kotlin-lsp-%s.zip",
					tag,
					tag
				)
				local zip = lsp_root .. ".zip"
				vim.fn.mkdir(data_dir, "p")
				vim.fn.system({ "curl", "-sL", "-o", zip, url })
				if vim.v.shell_error ~= 0 then
					vim.notify("KotlinLspInstall: download failed: " .. url, vim.log.levels.ERROR)
					return
				end
				vim.fn.system({ "unzip", "-o", zip, "-d", data_dir })
				os.remove(zip)
				-- zip extracts to kotlin-lsp/kotlinLSP-<os>-x64/<version>/run_scripts/kotlin-lsp.sh
				local script = vim.fn.glob(data_dir .. "/kotlin-lsp/*/run_scripts/kotlin-lsp.sh", false, true)[1]
				if script then
					os.rename(script, server_bin)
					os.execute("chmod +x " .. server_bin)
					vim.notify("Kotlin LSP installed: " .. server_bin .. " (restart nvim)", vim.log.levels.INFO)
				else
					vim.notify("KotlinLspInstall: kotlin-lsp.sh not found after extract", vim.log.levels.ERROR)
				end
			end

			vim.api.nvim_create_user_command("KotlinLspInstall", install_kotlin_lsp, {})

			-- ── Server command resolution ─────────────────────────────────────
			local cmd
			if vim.fn.filereadable(server_bin) == 1 then
				-- Official JetBrains Kotlin LSP
				cmd = { server_bin, "--stdio" }
			else
				-- Fallback to mason's kotlin-lsp if installed there
				local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/kotlin-lsp"
				if vim.fn.filereadable(mason_bin) == 1 then
					cmd = { mason_bin, "--stdio" }
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
		end,
	},
}
