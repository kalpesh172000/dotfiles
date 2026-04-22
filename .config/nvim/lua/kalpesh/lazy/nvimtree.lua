return {
	"nvim-tree/nvim-tree.lua",
	name = "nvim-tree",
	dependencies = {
		{ "ThePrimeagen/harpoon", branch = "harpoon2" },
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false, -- Ensures it's not lazy-loaded
	config = function()
		local harpoon = require("harpoon")
		-- disable netrw at the very start of your init.lua
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- optionally enable 24-bit colour
		vim.opt.termguicolors = true
		-- OR setup with some options
		require("nvim-tree").setup({
			renderer = {
				icons = {
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
					},
					glyphs = {
						default = "",
						symlink = "",
						folder = {
							default = "",
							open = "",
							empty = "",
							empty_open = "",
							symlink = "",
							symlink_open = "",
						},
					},
				},
			},

			on_attach = function(bufnr)
				local api = require("nvim-tree.api")

				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				-- Default mappings
				api.config.mappings.default_on_attach(bufnr)

				-- Custom mappings
				vim.keymap.set("n", "l", api.node.open.edit, opts("Open File or Expand Directory"))
				vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))

				-- Remove the default <C-e> mapping for nvim-tree inside the buffer
				vim.api.nvim_buf_del_keymap(bufnr, "n", "<C-e>")
			end,

			filters = {
				dotfiles = false,
			},
		})

		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		vim.keymap.set("n", "<leader>f", ":NvimTreeFindFileToggle<CR>")

		local function add_file_to_harpoon(node)
			local relative_path = vim.fn.fnamemodify(node.absolute_path, ":.") -- Get relative path
			local bufnr = vim.fn.bufnr(relative_path, false)

			-- Get the current cursor position, or default to {1, 0}
			local pos = { 1, 0 }
			if bufnr ~= -1 then
				pos = vim.api.nvim_win_get_cursor(0)
			end

			-- Create the HarpoonListItem
			local item = {
				value = relative_path, -- Use relative path as the value
				context = {
					row = pos[1],
					col = pos[2],
				},
			}

			-- Add the item to Harpoon's list
			harpoon:list():add(item)
		end

		-- Map the new functionality to a keybinding
		vim.keymap.set("n", "<leader>a", function()
			local api = require("nvim-tree.api")
			local node = api.tree.get_node_under_cursor()
			if node then
				add_file_to_harpoon(node)
			end
		end, { desc = "Add file to Harpoon from nvim-tree" })

		-- Restore NvimTree UI when entering Neovim
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				-- Don't run if Neovim is opening a specific file or files
				if vim.fn.argc() > 0 then
					return
				end

				-- Open the tree (no focus)
				require("nvim-tree.api").tree.open({ focus = false })

				-- Reload UI state (expanded / collapsed / cursor position)
				vim.schedule(function()
					require("nvim-tree.api").tree.reload()
				end)
			end,
		})

		-- this code is for closing the nvimtree gracefully
		-- what does it mean
		-- we dont want nvimtree to be last buffer getting closed
		-- so when we do :q in nvimtree it does
		-- 1-opens the last buffer
		-- 2-closes the nvimtree
		-- 3-does :q in the opened buffer
		-- Defer autocmd creation to avoid startup issues
		vim.schedule(function()
			-- Create the augroup ONCE
			local group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true })

			-- BETTER FIX: When trying to quit with only nvim-tree open,
			-- open the last buffer first, then quit
			vim.api.nvim_create_autocmd("QuitPre", {
				group = group,
				callback = function()
					local wins = vim.api.nvim_list_wins()
					local tree_wins = {}
					local normal_wins = 0

					-- Count windows and find nvim-tree
					for _, w in ipairs(wins) do
						local config = vim.api.nvim_win_get_config(w)
						-- Skip floating windows
						if config.relative == "" then
							local bufnr = vim.api.nvim_win_get_buf(w)
							local ft = vim.bo[bufnr].filetype

							if ft == "NvimTree" then
								table.insert(tree_wins, w)
							elseif ft ~= "noice" and ft ~= "notify" then
								normal_wins = normal_wins + 1
							end
						end
					end

					-- If only nvim-tree is open, switch to alternate buffer first
					if normal_wins == 0 and #tree_wins > 0 then
						-- Get the alternate buffer (last used buffer)
						local alt_buf = vim.fn.bufnr("#")

						-- If no alternate, try to find any listed buffer
						if alt_buf == -1 or not vim.api.nvim_buf_is_valid(alt_buf) then
							local buffers = vim.api.nvim_list_bufs()
							for _, buf in ipairs(buffers) do
								if
									vim.api.nvim_buf_is_loaded(buf)
									and vim.bo[buf].buflisted
									and vim.bo[buf].filetype ~= "NvimTree"
								then
									alt_buf = buf
									break
								end
							end
						end

						-- If we found a buffer, open it then close nvim-tree
						if alt_buf ~= -1 and vim.api.nvim_buf_is_valid(alt_buf) then
							-- Open the buffer in a new window
							vim.cmd("vsplit")
							vim.api.nvim_set_current_buf(alt_buf)
							-- Close nvim-tree
							require("nvim-tree.api").tree.close()
							vim.cmd("q")
						else
							-- No buffers to restore, just close nvim-tree and quit
							for _, w in ipairs(tree_wins) do
								vim.api.nvim_win_close(w, true)
							end
						end
					end
				end,
			})

			-- Optional: Open nvim-tree automatically when starting nvim with a directory
			vim.api.nvim_create_autocmd("VimEnter", {
				group = group,
				callback = function(data)
					local directory = vim.fn.isdirectory(data.file) == 1
					if directory then
						vim.cmd.cd(data.file)
						require("nvim-tree.api").tree.open()
					end
				end,
			})
		end)
	end,
}
