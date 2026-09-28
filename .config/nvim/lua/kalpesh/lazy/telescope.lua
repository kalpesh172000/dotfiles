return {
	"nvim-telescope/telescope.nvim",
	name = "telescope",

	--[[ commit = nil, ]]
	--[[ tag = "0.1.8", ]]
	--[[ branch= "0.1.x", ]]

	dependencies = {
		"plenary",
	},

	config = function()
		local actions = require("telescope.actions")
		require("telescope").setup({
			pickers = {
				buffers = {
					sort_mru = true,
					sort_lastused = true,
					ignore_current_buffer = true,
					theme = "dropdown",
					previewer = false,
					mappings = {
						n = {
							["d"] = actions.delete_buffer, -- press d to delete buffer
							["x"] = actions.delete_buffer, -- press x to delete buffer
						},
						i = {
							["<C-x>"] = actions.delete_buffer,
						},
					},
				},
				find_files = {
					hidden = true,
					no_ignore = true,
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--glob=!**/.git/*",
						"--glob=!**/.idea/*",
						"--glob=!**/.vscode/*",
						"--glob=!**/build/*",
						"--glob=!**/dist/*",
						"--glob=!**/yarn.lock",
						"--glob=!**/package-lock.json",
						"--glob=!**/node_modules/*",
					},
				},
			},
			defaults = {
				file_ignore_patterns = {
					"node_modules",
				},
				mappings = {
					n = {
						["q"] = actions.close, -- Press q in NORMAL mode to close Telescope
					},
				},
				vimgrep_arguments = {
					"rg",
					"--follow", -- Follow symbolic links
					"--hidden", -- Search for hidden files
					"--color=never",
					"--no-heading", -- Don't group matches by each file
					"--with-filename", -- Print the file path with the matched lines
					"--line-number", -- Show line numbers
					"--column", -- Show column numbers
					"--smart-case", -- Smart case search

					-- Exclude some patterns from search
					"--glob=!**/.git/*",
					"--glob=!**/.idea/*",
					"--glob=!**/.vscode/*",
					"--glob=!**/build/*",
					"--glob=!**/dist/*",
					"--glob=!**/yarn.lock",
					"--glob=!**/package-lock.json",
					"--glob=!**/node_modules/*",
				},
			},
		})

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
		vim.keymap.set("n", "<leader>pb", "<cmd>Telescope buffers<CR>", { desc = "List buffers" })
		vim.keymap.set("n", "<C-p>", builtin.git_files, {})
		vim.keymap.set("n", "<leader>pws", function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set("n", "<leader>pWs", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
		vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
		vim.keymap.set("n", "<leader>pg", "<cmd>Telescope live_grep<CR>")
	end,
}
