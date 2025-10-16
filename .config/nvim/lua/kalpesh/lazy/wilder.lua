return {
	"gelguy/wilder.nvim",
	lazy = true, -- optional, can remove if you want always loaded
	dependencies = { "nvim-web-devicons" },
	config = function()
		-- Wilder.nvim default setup
		-- Make sure you have installed wilder.nvim with your plugin manager

		-- Load wilder
		local wilder = require("wilder")

		-- Setup for command-line and search modes
		wilder.setup({ modes = { ":", "/", "?" } })

		-- Define pipelines: commands and search
		wilder.set_option("pipeline", {
			wilder.branch(
				-- Command mode pipeline
				wilder.cmdline_pipeline({
					fuzzy = 1, -- enable fuzzy matching
					fuzzy_filter = wilder.lua_fzy_filter(), -- nice scoring
				}),
				-- Search mode pipeline
				wilder.search_pipeline()
			),
		})

		-- Renderer: popup menu with highlights
		wilder.set_option(
			"renderer",
			wilder.popupmenu_renderer({
				-- Use basic highlighting
				highlighter = wilder.basic_highlighter(),
				left = { " ", wilder.popupmenu_devicons() },
				right = { " ", wilder.popupmenu_scrollbar() },
				max_height = "50%", -- limit height
				min_width = "20%", -- minimum width
			})
		)
	end,
}
