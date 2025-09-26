return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "prettier" },
				cpp = { "clang-format" },
				typescript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				java = { "google-java-format" },
				markdown = { "prettierd", "prettier" },
				rust = { "rustfmt" },
				erb = { "htmlbeautifier" },
				html = { "htmlbeautifier" },
				bash = { "beautysh" },
				toml = { "taplo" },
				css = { "prettierd", "prettier" },
				scss = { "prettierd", "prettier" },
				yarn = { "yaml-language-server" },
				go = { "gofumpt" },
				proto = { "buf" }, -- use buf for .proto files
			},
			stop_after_first = true, -- Apply stop_after_first globally
		})

		-- Always strip CR for Go files after formatting
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",
			callback = function(args)
				vim.api.nvim_buf_set_lines(
					args.buf,
					0,
					-1,
					false,
					vim.tbl_map(function(line)
						return line:gsub("\r", "")
					end, vim.api.nvim_buf_get_lines(args.buf, 0, -1, false))
				)
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "ConformFormatPost",
			callback = function(args)
				local buf = args.buf
				vim.api.nvim_buf_set_lines(
					buf,
					0,
					-1,
					false,
					vim.tbl_map(function(line)
						return line:gsub("\r", "")
					end, vim.api.nvim_buf_get_lines(buf, 0, -1, false))
				)
				-- Force fileformat to unix just in case
				vim.bo[buf].fileformat = "unix"
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>l", function()
			require("conform").format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})

			-- cleanup CR (^M) characters and force LF
			local buf = vim.api.nvim_get_current_buf()
			vim.api.nvim_buf_set_lines(
				buf,
				0,
				-1,
				false,
				vim.tbl_map(function(line)
					return line:gsub("\r", "")
				end, vim.api.nvim_buf_get_lines(buf, 0, -1, false))
			)
			vim.bo[buf].fileformat = "unix"
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
