return {
	"williamboman/mason.nvim",
	config = function()
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
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗"
				}
			}
		})
	end,
}
