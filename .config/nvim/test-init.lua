local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
	{ "nvim-lua/plenary.nvim", build = false },
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls" },
			})
		end,
	},
}, {
	rocks = { enabled = false },
})

-- Your lua_ls config (Mason-managed)
vim.lsp.config.lua_ls = {
	cmd = { vim.fn.exepath("lua-language-server") },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
	settings = {
		Lua = {
			runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
			diagnostics = { globals = { "vim" } },
			workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
			telemetry = { enable = false },
			format = { enable = false },
		},
	},
}

-- Test function
vim.keymap.set("n", "<leader>t", function()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Test", "Window" })
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = 20,
		height = 5,
		row = 1,
		col = 1,
		border = "single",
	})
	print("Window created:", win)
end)
