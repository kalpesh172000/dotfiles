return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	name = "lualine",
	config = function()
		require("lualine").setup({
			sections = {
				lualine_c = {
					{ "filename", path = 3 }, -- 3 = absolute path
				},
			},
			options = {
				theme = "auto",
				globalstatus = true, -- same as laststatus=3
			},
		})
	end,
}
