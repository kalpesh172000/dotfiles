return function(capabilities)
	local function exe(name)
		local p = vim.fn.exepath(name)
		return (p ~= nil and p ~= "") and p or name
	end

	-- LSP Configurations using vim.lsp.config

	-- C/C++ Language Server
	vim.lsp.config.clangd = {
		cmd = {
			exe("clangd"),
			"--background-index",
			"--clang-tidy",
			"--completion-style=detailed",
			"--header-insertion=iwyu",
						"--all-scopes-completion",
			"--function-arg-placeholders=1",
		},
		root_markers = {
			"compile_commands.json",
			"compile_flags.txt",
			".clangd",
			"build/compile_commands.json",
			"CMakeLists.txt",
			"Makefile",
			".git",
		},
		capabilities = vim.tbl_deep_extend("force", capabilities or {}, {
			offsetEncoding = { "utf-16" },
		}),
		init_options = {
			usePlaceholders = true,
			completeUnimported = true,
			clangdFileStatus = true,
		},
	}

	-- CSS Language Server
	vim.lsp.config.cssls = {
		cmd = { exe("vscode-css-language-server"), "--stdio" },
		root_markers = { "package.json", ".git" },
		settings = {
			css = {
				validate = true,
				lint = {
					unknownAtRules = "ignore",
				},
			},
			scss = {
				validate = true,
				lint = {
					unknownAtRules = "ignore",
				},
			},
			less = {
				validate = true,
				lint = {
					unknownAtRules = "ignore",
				},
			},
		},
	}

	-- Emmet Language Server
	vim.lsp.config.emmet_language_server = {
		cmd = { exe("emmet-language-server"), "--stdio" },
		root_markers = { "package.json", ".git" },
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
		init_options = {
			includeLanguages = {},
			excludeLanguages = {},
			extensionsPath = {},
			preferences = {},
			showAbbreviationSuggestions = true,
			showExpandedAbbreviation = "always",
			showSuggestionsAsSnippets = false,
			syntaxProfiles = {},
			variables = {},
		},
	}

	-- HTML Language Server
	vim.lsp.config.html = {
		cmd = { exe("vscode-html-language-server"), "--stdio" },
		root_markers = { "package.json", ".git" },
		init_options = {
			configurationSection = { "html", "css", "javascript" },
			embeddedLanguages = {
				css = true,
				javascript = true,
			},
			provideFormatter = true,
		},
		settings = {
			html = {
				validate = true,
				hover = {
					documentation = true,
					references = true,
				},
			},
		},
	}

	-- JSON Language Server
	vim.lsp.config.jsonls = {
		cmd = { exe("vscode-json-language-server"), "--stdio" },
		root_markers = { "package.json", ".git" },
		init_options = {
			provideFormatter = true,
		},
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	}

	-- Lua Language Server
	vim.lsp.config.lua_ls = {
		cmd = { exe("lua-language-server") },
		root_markers = {
			".luarc.json",
			".luarc.jsonc",
			".luacheckrc",
			".stylua.toml",
			"stylua.toml",
			"selene.toml",
			"selene.yml",
			".git",
		},
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = { vim.env.VIMRUNTIME },
					checkThirdParty = false,
				},
				telemetry = {
					enable = false,
				},
				format = {
					enable = false, -- Use stylua instead
				},
			},
		},
	}

	-- Rust Analyzer
	vim.lsp.config.rust_analyzer = {
		cmd = { exe("rust-analyzer") },
		root_markers = {
			"Cargo.toml",
			"Cargo.lock",
			"rust-project.json",
			".git",
		},
		settings = {
			["rust-analyzer"] = {
				diagnostics = { enable = false }, -- Keep rust-analyzer diagnostics
				checkOnSave = false, -- Prevent rustc from running `check`
				check = { command = "clippy" }, -- Prevent rustc from running `check`
				cargo = {
					buildScripts = { enable = true },
					allFeatures = true,
					loadOutDirsFromCheck = true,
					runBuildScripts = true,
				},
				procMacro = {
					enable = true,
					ignored = {
						["async-trait"] = { "async_trait" },
						["napi-derive"] = { "napi" },
						["async-recursion"] = { "async_recursion" },
					},
				},
			},
		},
		flags = {
			debounce_text_changes = 500,
			exit_timeout = 1000,
		},
	}

	-- Tailwind CSS Language Server
	vim.lsp.config.tailwindcss = {
		cmd = { exe("tailwindcss-language-server"), "--stdio" },
		root_markers = {
			"tailwind.config.js",
			"tailwind.config.ts",
			"tailwind.config.cjs",
			"tailwind.config.mjs",
			"package.json",
			".git",
		},
		init_options = {
			userLanguages = {
				eelixir = "html-eex",
				eruby = "erb",
				rust = "html",
			},
		},
		settings = {
			tailwindCSS = {
				classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
				lint = {
					cssConflict = "warning",
					invalidApply = "error",
					invalidConfigPath = "error",
					invalidScreen = "error",
					invalidTailwindDirective = "error",
					invalidVariant = "error",
					recommendedVariantOrder = "warning",
				},
				validate = true,
			},
		},
	}

	-- TypeScript Language Server
	vim.lsp.config.ts_ls = {
		on_attach = function(client, bufnr)
			local function buf_set_keymap(...)
				vim.api.nvim_buf_set_keymap(bufnr, ...)
			end
			local opts = { noremap = true, silent = true }

			-- Useful key mappings
			-- Goes to the place where function was defined
			buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
			-- Goes to the place where fucnction was referenced/called
			buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
			-- Goes to the implementation of an interface or abstract fuction
			buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
			-- Displays documentation about the function/variable in a floating window
			buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
			-- **Go to type definition**
			vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, opts)
		end,
		cmd = { exe("typescript-language-server"), "--stdio" },
		root_markers = {
			"package.json",
			"tsconfig.json",
			"jsconfig.json",
			".git",
		},
		init_options = {
			hostInfo = "neovim",
		},
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "literal",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	}

	-- YAML Language Server
	vim.lsp.config.yamlls = {
		cmd = { exe("yaml-language-server"), "--stdio" },
		root_markers = {
			".yamllint",
			".yamllint.yml",
			".yamllint.yaml",
			"package.json",
			".git",
		},
		settings = {
			yaml = {
				schemas = {
					["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
					["https://json.schemastore.org/github-action.json"] = "/action.{yml,yaml}",
					["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.{yml,yaml}",
					["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
					["https://json.schemastore.org/chart.json"] = "Chart.{yml,yaml}",
				},
				validate = true,
				completion = true,
				hover = true,
			},
		},
	}

	-- GO Language Server
	vim.lsp.config.gopls = {
		on_attach = function(client, bufnr)
			local function buf_set_keymap(...)
				vim.api.nvim_buf_set_keymap(bufnr, ...)
			end
			local opts = { noremap = true, silent = true }

			-- Useful key mappings
			-- Goes to the place where function was defined
			buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
			-- Goes to the place where fucnction was referenced/called
			buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
			-- Goes to the implementation of an interface or abstract fuction
			buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
			-- Displays documentation about the function/variable in a floating window
			--buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
		end,
		cmd = { exe("gopls") },
		root_markers = {
			"go.mod",
			"go.sum",
			"go.work",
			"go.work.sum",
			"Gopkg.toml",
			"Gopkg.lock",
		},
		init_options = {
			usePlaceholders = true,
			completeUnimported = true,
		},
		settings = {
			gopls = {
				-- General settings
				gofumpt = true,
				codelenses = {
					gc_details = false,
					generate = true,
					regenerate_cgo = true,
					run_govulncheck = true,
					test = true,
					tidy = true,
					upgrade_dependency = true,
					vendor = true,
				},
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
				analyses = {
					--fieldalignment = true,
					nilness = true,
					unusedparams = true,
					unusedwrite = true,
					useany = true,
				},
				usePlaceholders = true,
				completeUnimported = true,
				staticcheck = true,
				directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
				semanticTokens = true,
				-- Build settings
				buildFlags = { "-tags", "integration" },
				env = {
					GOFLAGS = "-tags=integration",
				},
				-- Import organization
				["local"] = "",
			},
		},
		flags = {
			debounce_text_changes = 200,
			exit_timeout = 1000,
		},
	}

	-- Buf Language Server
	vim.lsp.config.bufls = {
		cmd = { exe("bufls") },
		filetypes = { "proto" },
		root_markers = {
			"buf.yaml",
			"buf.work.yaml",
			".git",
		},
		settings = {
			buf = {
				-- Enable formatting using buf format
				formatting = {
					enabled = true,
				},
			},
		},
	}

	-- ESLint Language Server
	vim.lsp.config.eslint = {
		cmd = { exe("vscode-eslint-language-server"), "--stdio" },
		root_markers = {
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.json",
			"eslint.config.js",
			"package.json",
			".git",
		},
		filetypes = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
		},
		settings = {
			format = true,
			validate = "on",
			codeAction = {
				disableRuleComment = {
					enable = true,
					location = "separateLine",
				},
				showDocumentation = {
					enable = true,
				},
			},
			run = "onType",
			workingDirectory = { mode = "auto" },
		},
		on_attach = function(client, bufnr)
			-- Enable ESLint formatting
			client.server_capabilities.documentFormattingProvider = true
		end,
	}

	-- GLSL Language Server (glsl_analyzer)
	vim.filetype.add({
		extension = {
			vert = "glsl",
			frag = "glsl",
			comp = "glsl",
			geom = "glsl",
			tesc = "glsl",
			tese = "glsl",
			glsl = "glsl",
			rgen = "glsl",
			rint = "glsl",
			rahit = "glsl",
			rchit = "glsl",
			rmiss = "glsl",
			rcall = "glsl",
		},
	})

	vim.lsp.config.glsl_analyzer = {
		cmd = { exe("glsl_analyzer") },
		filetypes = { "glsl", "vert", "tesc", "tese", "geom", "frag", "comp", "rgen", "rint", "rahit", "rchit", "rmiss", "rcall" },
		root_markers = {
			".git",
			"compile_commands.json",
			"CMakeLists.txt",
			"Makefile",
		},
	}

	-- Custom notification filter for rust-analyzer
	--[[
local notify_builtin = vim.notify
vim.notify = function(msg, log_level, opts)
    if msg == "rust_analyzer: -32802: server cancelled the request" then
        return
    else
        notify_builtin(msg, log_level, opts)
    end
end
--]]
	-- Servers to manage
	local servers = {
		"clangd",
		"cssls",
		"emmet_language_server",
		"html",
		"jsonls",
		"lua_ls",
		"rust_analyzer",
		"tailwindcss",
		"ts_ls",
		"yamlls",
		"gopls",
		"bufls",
		"eslint",
		"glsl_analyzer",
	}

	-- Helper to enable a server only if its executable exists
	local function enable_if_executable(server_name)
		local cfg = vim.lsp.config[server_name]
		local cmd = cfg and cfg.cmd and cfg.cmd[1]
		if cmd and vim.fn.executable(cmd) == 1 then
			vim.lsp.enable({ server_name })
			return true
		end
		return false
	end

	-- Only enable servers that are currently installed/executable
	for _, server in ipairs(servers) do
		enable_if_executable(server)
	end

	-- Automatically enable newly installed servers from Mason without restarting Neovim
	local has_mason_registry, mason_registry = pcall(require, "mason-registry")
	if has_mason_registry then
		mason_registry:on("package:install:success", function()
			vim.schedule(function()
				for _, server in ipairs(servers) do
					enable_if_executable(server)
				end
			end)
		end)
	end
end
