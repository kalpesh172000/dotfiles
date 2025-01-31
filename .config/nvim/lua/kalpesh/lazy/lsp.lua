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
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

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
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
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
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,


                ["emmet_language_server"] = function()
                    require("lspconfig").emmet_language_server.setup({
                        filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
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
            }
        })
        ---------------------- MASON-LSPCONFIG END ----------------------




        ---------------------- CMP SETUP START ----------------------
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
            }),
        })
        ---------------------- CMP SETUP START ----------------------




        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
        local autopairs = require("nvim-autopairs")
        autopairs.setup({})

        -- Integration with nvim-cmp for better pairing behavior
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
}
