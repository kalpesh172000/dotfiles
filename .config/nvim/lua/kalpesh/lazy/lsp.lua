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
				source = "always",
				header = "",
				prefix = "",
			},
		})
		-- for warning and error wrap work in floating window
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				vim.diagnostic.open_float(nil, { focusable = false, wrap = true, border = "rounded", max_width = 80 })
			end,
		})

		local autopairs = require("nvim-autopairs")
		autopairs.setup({})

		-- Integration with nvim-cmp for better pairing behavior
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
