return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		"windwp/nvim-autopairs",
		"luckasRanarison/tailwind-tools.nvim",
		"b0o/schemastore.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup({})
		require("mason").setup({
			PATH = "prepend", -- Ensure Mason binaries are found first
			install_root_dir = vim.fn.stdpath("data") .. "/mason",
			log_level = vim.log.levels.INFO,
			pip = {
				upgrade_pip = true,
				install_args = {}, -- Additional arguments to `pip install`
			},
			python = {
				executable = "python3", -- Ensure the correct Python interpreter is used
			},
		})

		---------------------- LSP CONFIGURATION START--------------------
		local mason_registry = require("mason-registry")

		local servers = { "lua-language-server" }

		for _, server in ipairs(servers) do
			if not mason_registry.is_installed(server) then
				mason_registry.get_package(server):install()
			end
		end

		local server_setup = require("kalpesh.servers")
		server_setup()
		---------------------- LSP CONFIGURATION END--------------------

		---------------------- MASON-LSPCONFIG START ----------------------
		require("mason-lspconfig").setup({})

		---------------------- MASON-LSPCONFIG END ----------------------

		----------------------  TAILWIND-TOOLS START ----------------------

		require("tailwind-tools").setup({
			-- Preview configuration for Tailwind classes (optional)
			preview = {
				enabled = true, -- Enable preview feature for Tailwind classes
				open_cmd = "vsplit", -- How to open the preview window (e.g., vsplit, split, tabnew)
				auto_open = true, -- Automatically open preview on cursor hold (set to true if desired)
				-- this is the option that makes base css visible
				--[[ width = 80, -- (Optional) Preview window width ]]
				--[[ height = 15, -- (Optional) Preview window height ]]
			},

			-- Filetypes where tailwind-tools should be active
			filetypes = {
				"html",
				"css",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
			},

			-- (Optional) Specify the path to your tailwind config file if it isn't at the default location.
			-- config_path = "tailwind.config.js",

			-- (Optional) Additional settings can be added here if needed.
		})
		vim.api.nvim_set_keymap(
			"n",
			"<leader>tw",
			"<cmd>TailwindToolsPreview<CR>",
			{ noremap = true, silent = true, desc = "Open Tailwind Preview" }
		)
		----------------------  TAILWIND-TOOLS END ----------------------

		---------------------- CMP SETUP START ----------------------
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			}),
		})
		---------------------- CMP SETUP START ----------------------
		-- Set transparent background for diagnostic floating windows
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				-- Make diagnostic float background transparent
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
				vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

				-- Optional: Make the diagnostic text backgrounds transparent too
				vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { bg = "none" })
				vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { bg = "none" })
				vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { bg = "none" })
				vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { bg = "none" })
			end,
		})

		-- Trigger the highlight changes immediately if colorscheme is already loaded
		vim.cmd("doautocmd ColorScheme")

		vim.diagnostic.config({
			-- update_in_insert = true,
			virtual_text = {
				wrap = true, -- Enable wrapping in virtual text
			},
			float = {
				wrap = true, -- Enable wrapping in floating windows
				max_width = 80, -- Adjust width to fit screen
				focusable = true,
				style = "minimal",
				border = "rounded",
				source = true,
				header = "",
				prefix = "",
			},
		})
		-- for warning and error wrap work in floating window
		-- Better diagnostic float handling
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				-- Only show diagnostics if there are any at the current position
				local opts = {
					focusable = false,
					close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
					border = "rounded",
					source = true,
					prefix = " ",
					scope = "cursor", -- Only show diagnostics for current cursor position
				}

				-- Check if there are diagnostics at current position before opening
				local line = vim.api.nvim_win_get_cursor(0)[1] - 1
				local diagnostics = vim.diagnostic.get(0, { lnum = line })

				if #diagnostics > 0 then
					vim.diagnostic.open_float(nil, opts)
				end
			end,
		})

		-- Close diagnostic floats when switching buffers or moving cursor
		vim.api.nvim_create_autocmd({ "BufLeave", "CursorMoved", "CursorMovedI" }, {
			callback = function()
				-- Close any open diagnostic floats
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local config = vim.api.nvim_win_get_config(win)
					if config.relative ~= "" then -- It's a floating window
						local buf = vim.api.nvim_win_get_buf(win)
						local buf_name = vim.api.nvim_buf_get_name(buf)
						-- Close if it's likely a diagnostic float (empty name, small buffer)
						if buf_name == "" and vim.api.nvim_buf_line_count(buf) < 20 then
							pcall(vim.api.nvim_win_close, win, true)
						end
					end
				end
			end,
		})

		-- Alternative: Use a more targeted approach with keymaps instead of autocmd
		-- Comment out the autocmd above and use this instead if you prefer manual control:
		--[[
vim.keymap.set("n", "<leader>d", function()
	vim.diagnostic.open_float(nil, {
		focusable = false,
		close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
		border = "rounded",
		source = true,
		prefix = " ",
		scope = "cursor",
		wrap = true,
		max_width = 80,
	})
end, { desc = "Show line diagnostics" })
]]

		local autopairs = require("nvim-autopairs")
		autopairs.setup({})
		-- Integration with nvim-cmp for better pairing behavior
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
