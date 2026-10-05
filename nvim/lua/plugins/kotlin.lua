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
	-- 3) Kotlin LSP setup lives in lua/config/kotlin.lua (loaded via lsp.lua).
	--    NOTE: Do NOT add another nvim-lspconfig spec here — lazy.nvim merges
	--    this spec's ft/cmd triggers onto the main lspconfig spec, which
	--    prevents nvim-lspconfig from ever loading for other filetypes
	--    (TS/JS LSP silently stops working).
	----------------------------------------------------------------------------
}
