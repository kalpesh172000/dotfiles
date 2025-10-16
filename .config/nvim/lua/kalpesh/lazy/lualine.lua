return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	name = "lualine",
	config = function()
		require("lualine").setup({
			options = {
				theme = "auto",
				globalstatus = true, -- same as laststatus=3
			},
		})
	end,
}
