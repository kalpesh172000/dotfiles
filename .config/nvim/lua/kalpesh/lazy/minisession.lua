return {
	"echasnovski/mini.sessions",
	version = false,
	config = function()
		require("mini.sessions").setup({
			autoread = true, -- automatically restore last session
			autowrite = true, -- automatically save on exit
		})
	end,
}
