return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {},
	ft = { "markdown" },
	keys = {
		{
			"<leader>mr",
			"<cmd>RenderMarkdown toggle<cr>",
			desc = "Toggle Render Markdown",
		},
		{
			"<leader>mt",
			"<cmd>RenderMarkdown toggle<cr>",
			desc = "Toggle Render Markdown",
		},
	},
}
