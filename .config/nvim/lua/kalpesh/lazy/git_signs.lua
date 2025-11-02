return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { hl = "GitGutterAdd", text = "+", numhl = "GitSignsAddNr" },
				change = { hl = "GitGutterChange", text = "~", numhl = "GitSignsChangeNr" },
				delete = { hl = "GitGutterDelete", text = "_", numhl = "GitSignsDeleteNr" },
				topdelete = { hl = "GitGutterDelete", text = "‾", numhl = "GitSignsDeleteNr" },
				changedelete = { hl = "GitGutterChange", text = "~", numhl = "GitSignsChangeNr" },
			},
			current_line_blame = true, -- optional
			signcolumn = true,
			numhl = false,
		})

		vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = "#00ff00" })
		vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = "#ffff00" })
		vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = "#ff0000" })

		vim.keymap.set("n", "<leader>hs", ":Gitsigns stage_hunk<CR>")
		vim.keymap.set("n", "<leader>hu", ":Gitsigns undo_stage_hunk<CR>")
		vim.keymap.set("n", "<leader>hp", ":Gitsigns preview_hunk<CR>")
		vim.keymap.set("n", "<leader>hb", ":Gitsigns blame_line<CR>")
	end,
}
