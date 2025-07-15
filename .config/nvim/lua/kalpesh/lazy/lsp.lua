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

		vim.lsp.config.lua_ls = {
			cmd = { vim.fn.exepath("lua-language-server") },
			root_markers = {
				".luarc.json",
				".luarc.jsonc",
				".luacheckrc",
				".stylua.toml",
				"stylua.toml",
				"selene.toml",
				"selene.yml",
			},
			settings = {
				Lua = {
					diagnostics = {
						globals = {"vim"},
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		}
        ---------------------- LSP CONFIGURATION START--------------------

		---------------------- MASON-LSPCONFIG START ----------------------
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"clangd",
				"rust_analyzer",
				-- :MasonInstall emmet-language-server
				--"emmet-language-server", -- For HTML tag auto-completion
				"cssls", -- For CSS property suggestions
			},
			automatic_enable = true,
			automatic_installation = true,
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				zls = function()
					local lspconfig = require("lspconfig")
					lspconfig.zls.setup({
						root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
						settings = {
							zls = {
								enable_inlay_hints = true,
								enable_snippets = true,
								warn_style = true,
							},
						},
					})
					vim.g.zig_fmt_parse_errors = 0
					vim.g.zig_fmt_autosave = 0
				end,

				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = {
									-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
									version = "LuaJIT",
									path = vim.split(package.path, ";"),
								},
								diagnostics = {
									-- Get the language server to recognize the `vim` global
									globals = { "vim" },
								},
								workspace = {
									-- Make the server aware of Neovim runtime files and plugins
									library = { vim.env.VIMRUNTIME },
									checkThirdParty = false,
								},
								telemetry = {
									enable = false,
								},
							},
						},
					})
				end,

				["emmet_language_server"] = function()
					require("lspconfig").emmet_language_server.setup({
						filetypes = {
							"css",
							"eruby",
							"html",
							"javascript",
							"javascriptreact",
							"less",
							"sass",
							"scss",
							"pug",
							"typescriptreact",
						},
						-- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
						-- **Note:** only the options listed in the table are supported.
						init_options = {
							---@type table<string, string>
							includeLanguages = {},
							--- @type string[]
							excludeLanguages = {},
							--- @type string[]
							extensionsPath = {},
							--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
							preferences = {},
							--- @type boolean Defaults to `true`
							showAbbreviationSuggestions = true,
							--- @type "always" | "never" Defaults to `"always"`
							showExpandedAbbreviation = "always",
							--- @type boolean Defaults to `false`
							showSuggestionsAsSnippets = false,
							--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
							syntaxProfiles = {},
							--- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
							variables = {},
						},
					})
				end,

				-- congiguration for the cssls which was added to mason ensure_installed
				["cssls"] = function()
					require("lspconfig").cssls.setup({
						capabilities = capabilities,
						settings = {
							css = {
								validate = true,
							},
							less = {
								validate = true,
							},
							scss = {
								validate = true,
							},
						},
					})
				end,

				["rust_analyzer"] = function()
					require("lspconfig").rust_analyzer.setup({
						capabilities = capabilities,
						settings = {
							["rust-analyzer"] = {
								diagnostics = { enable = false }, -- Keep rust-analyzer diagnostics
								checkOnSave = { command = "clippy" }, -- Prevent rustc from running `check`
								cargo = { buildScripts = { enable = true } },
								procMacro = { enable = true },
							},
						},
						flags = { debounce_text_changes = 500 },
					})

					local notify_builtin = vim.notify
					vim.notify = function(msg, log_level, opts)
						if msg == "rust_analyzer: -32802: server cancelled the request" then
							return
						else
							notify_builtin(msg, log_level, opts)
						end
						--[[ require("notify")(msg, log_level, opts) -- Use notify for everything else ]]
					end
				end,

				--[[ ["typescript-language-server"] = function() ]]
				--[[     require("lspconfig").ts_ls.setup({ ]]
				--[[         capabilities = capabilities, ]]
				--[[         filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" }, -- Ensure TSX support ]]
				--[[         settings = { ]]
				--[[             typescript = { ]]
				--[[                 inlayHints = { includeInlayParameterNameHints = "all" } ]]
				--[[             }, ]]
				--[[             javascript = { ]]
				--[[                 inlayHints = { includeInlayParameterNameHints = "all" } ]]
				--[[             } ]]
				--[[         } ]]
				--[[     }) ]]
				--[[ end ]]
			},
		})

		--[[ vim.lsp.handlers["window/showMessage"] = function(_, result, ctx) ]]
		--[[     if result.type <= 3 then -- Prevents errors & warnings from appearing in command line ]]
		--[[         return ]]
		--[[     end ]]
		--[[     vim.notify(result.message, "info", { title = "LSP", timeout = 3000 }) ]]
		--[[ end ]]

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
