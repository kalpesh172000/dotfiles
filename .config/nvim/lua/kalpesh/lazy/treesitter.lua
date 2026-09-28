return {
	-- Treesitter plugin
	{
		"nvim-treesitter/nvim-treesitter",
		name = "treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"vimdoc",
					"javascript",
					"typescript",
					"c",
					"lua",
					"rust",
					"jsdoc",
					"bash",
					"cpp",
					"python",
					"html",
					"css",
					"go",
					"proto", -- Add any languages you need
					"glsl",
					"markdown",
					"markdown_inline",
				},
				sync_install = false,
				auto_install = true,
				indent = { enable = true },
				highlight = { enable = true },
				rainbow = {
					enable = true, -- Enables rainbow brackets
					extended_mode = true, -- Highlight brackets, parentheses, and more
					max_file_lines = 1000, -- Disable for large files
				},
			})

			local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			treesitter_parser_config.templ = {
				install_info = {
					url = "https://github.com/vrischmann/tree-sitter-templ.git",
					files = { "src/parser.c", "src/scanner.c" },
					branch = "master",
				},
			}

			-- This is where the code folding code goes
			-- this because the code folding is using the treesitter for feguring out how to fold the code
			-- ------------------------------
			-- 🌳 Basic Folding Configuration
			-- ------------------------------
			local opt = vim.opt

			-- Set fold method to expression (for Tree-sitter)
			opt.foldmethod = "expr"
			opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

			-- Start with all folds open (high number = everything unfolded)
			opt.foldlevel = 99
			opt.foldlevelstart = 99
			opt.foldenable = true

			-- Show fold column (optional - shows fold indicators on left)
			--opt.foldcolumn = "1"

			-- Nicer fold appearance
			--opt.foldcolumn = "2" -- Wide fold column
			vim.api.nvim_set_hl(0, "Folded", { bg = "#282c34", fg = "#e5c07b", bold = true })
			vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#e06c75", bold = true })
            --[[
			vim.opt.fillchars = {
				fold = "━",
				foldopen = "▼",
				foldclose = "▶",
				foldsep = "┃",
			}

			vim.opt.fillchars = {
				fold = " ",
				foldopen = "",
				foldsep = " ",
				foldclose = "",
			}
				fold = " ",
                opt.fillchars = {
                    foldopen = "",
                    foldclose = "",
                    foldsep = " ",
                }
            --]]

			-- ------------------------------
			-- 🧠 Better Fold Text (Neovim 0.10+)
			-- ------------------------------
			-- For Neovim 0.10+, use the new foldtext function
			if vim.fn.has("nvim-0.10") == 1 then
				opt.foldtext = "" -- Use default modern foldtext
			else
				-- Fallback for older versions
				opt.foldtext =
					[[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) ]]
			end

			-- ------------------------------
			-- 🔑 Essential Keymaps
			-- ------------------------------
			local keymap = vim.keymap.set

			-- Default fold commands (these should work by default, but let's ensure)
			keymap("n", "zc", "zc", { desc = "Close fold under cursor", noremap = true })
			keymap("n", "zo", "zo", { desc = "Open fold under cursor", noremap = true })
			keymap("n", "za", "za", { desc = "Toggle fold under cursor", noremap = true })
			keymap("n", "zM", "zM", { desc = "Close all folds", noremap = true })
			keymap("n", "zR", "zR", { desc = "Open all folds", noremap = true })
			keymap("n", "zm", "zm", { desc = "Fold more (increase fold level)", noremap = true })
			keymap("n", "zr", "zr", { desc = "Fold less (decrease fold level)", noremap = true })

			-- Additional useful keymaps
			keymap("n", "zC", "zC", { desc = "Close all folds under cursor recursively", noremap = true })
			keymap("n", "zO", "zO", { desc = "Open all folds under cursor recursively", noremap = true })
			keymap("n", "zj", "zj", { desc = "Move to next fold", noremap = true })
			keymap("n", "zk", "zk", { desc = "Move to previous fold", noremap = true })

			-- Custom leader shortcuts (uncomment if you want)
			-- keymap('n', '<leader>fc', 'zc', { desc = "Close fold" })
			-- keymap('n', '<leader>fo', 'zo', { desc = "Open fold" })
			-- keymap('n', '<leader>fa', 'za', { desc = "Toggle fold" })
			-- keymap('n', '<leader>fO', 'zR', { desc = "Open all folds" })
			-- keymap('n', '<leader>fC', 'zM', { desc = "Close all folds" })

			-- ------------------------------
			-- 🛠️ Troubleshooting Function
			-- ------------------------------
			-- Run :lua CheckFoldingSetup() to diagnose issues
			function CheckFoldingSetup()
				print("=== Folding Configuration Check ===")
				print("Fold method: " .. vim.o.foldmethod)
				print("Fold expr: " .. vim.o.foldexpr)
				print("Fold level: " .. vim.o.foldlevel)
				print("Folding enabled: " .. tostring(vim.o.foldenable))

				-- Check if Tree-sitter is available
				local ts_ok, _ = pcall(require, "nvim-treesitter")
				if ts_ok then
					print("✅ Tree-sitter is installed")

					-- Check if parser exists for current buffer
					local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
					if lang then
						local parser_ok = pcall(vim.treesitter.get_parser, 0, lang)
						if parser_ok then
							print("✅ Parser available for: " .. vim.bo.filetype)
						else
							print("❌ No parser for: " .. vim.bo.filetype)
							print("   Run: :TSInstall " .. vim.bo.filetype)
						end
					else
						print("❌ No language mapping for filetype: " .. vim.bo.filetype)
					end
				else
					print("❌ Tree-sitter NOT installed!")
					print("   Install nvim-treesitter plugin first")
				end

				-- Check fold text function
				if vim.fn.has("nvim-0.10") == 1 then
					print("✅ Neovim 0.10+ detected - using modern foldtext")
				else
					print("⚠️  Neovim < 0.10 - using fallback foldtext")
				end
			end

			-- Command to check setup
			vim.api.nvim_create_user_command("CheckFolding", CheckFoldingSetup, {})

			-- ------------------------------
			-- 🚀 Auto-save fold state (optional)
			-- ------------------------------
			-- Uncomment to remember fold state when closing files
			--[[
            vim.api.nvim_create_autocmd("BufWinLeave", {
              pattern = "*",
              command = "mkview",
            })

            vim.api.nvim_create_autocmd("BufWinEnter", {
              pattern = "*",
              command = "silent! loadview",
            })
            ]]
		end,
	},
	-- Rainbow brackets plugin
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "BufRead", -- Load on buffer read for performance
		config = function()
			-- This module contains a number of default definitions
			local rainbow_delimiters = require("rainbow-delimiters")

			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				priority = {
					[""] = 110,
					lua = 210,
				},
				highlight = {
					--                    'RainbowDelimiterRed',
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterCyan",
					"RainbowDelimiterViolet",
					"RainbowDelimiterGreen",
				},
			}
		end,
	},
}
