-- Minimal nvim-tree setup with fix for the "last window" bug
-- Save this as ~/.config/nvim/init.lua (or add to your existing config)

-- Install lazy.nvim if not already installed
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

-- Setup plugins
require("lazy").setup({
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			{ "ThePrimeagen/harpoon", branch = "harpoon2" },
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local harpoon = require("harpoon")

			-- Disable netrw (recommended)
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			require("nvim-tree").setup({
				-- Your nvim-tree configuration here
				view = {
					width = 30,
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = false,
				},

				on_attach = function(bufnr)
					local api = require("nvim-tree.api")

					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end

					-- Default mappings
					api.config.mappings.default_on_attach(bufnr)

					-- Custom mappings
					vim.keymap.set("n", "l", api.node.open.edit, opts("Open File or Expand Directory"))
					vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))

					-- Remove the default <C-e> mapping for nvim-tree inside the buffer
					vim.api.nvim_buf_del_keymap(bufnr, "n", "<C-e>")
				end,
			})

			-- Set up Harpoon keybinding globally (no need for BufEnter)
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Toggle Harpoon Menu" })

            --[[
			-- THE FIX: Auto-close nvim-tree if it's the last window when quitting
			-- This prevents the broken state when reopening, but lets you keep it open during work
			vim.api.nvim_create_autocmd("QuitPre", {
				callback = function()
					local tree_wins = {}
					local floating_wins = {}
					local wins = vim.api.nvim_list_wins()

					for _, w in ipairs(wins) do
						local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
						if bufname:match("NvimTree_") ~= nil then
							table.insert(tree_wins, w)
						end
						if vim.api.nvim_win_get_config(w).relative ~= "" then
							table.insert(floating_wins, w)
						end
					end

					-- If nvim-tree is the last non-floating window, close it before quit
					-- This only triggers when you're actually quitting vim
					if #wins - #floating_wins - #tree_wins == 0 then
						for _, w in ipairs(tree_wins) do
							vim.api.nvim_win_close(w, true)
						end
					end
				end,
			})
            --]]

			-- Keybindings
			vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle NvimTree" })
			vim.keymap.set("n", "<leader>o", ":NvimTreeFocus<CR>", { silent = true, desc = "Focus NvimTree" })

            --[[
			-- Optional: Open nvim-tree automatically when starting nvim with a directory
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function(data)
					local directory = vim.fn.isdirectory(data.file) == 1
					if directory then
						vim.cmd.cd(data.file)
						require("nvim-tree.api").tree.open()
					end
				end,
			})
            --]]
		end,
	},
	{
		"nvim-lua/plenary.nvim",
		name = "plenary",
		priority = 1000,
		lazy = false,
		build = false,
	},
})
