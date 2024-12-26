return {
    "nvim-tree/nvim-tree.lua",
    name = "nvim-tree",
    dependencies = {
        {"ThePrimeagen/harpoon", branch = "harpoon2"},
        "nvim-tree/nvim-web-devicons",
    },
    lazy = false, -- Ensures it's not lazy-loaded
    config = function()

        local harpoon = require("harpoon");
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
                vim.api.nvim_buf_del_keymap(bufnr, 'n', '<C-e>')

            end,

            filters = {
                dotfiles = false,
            },
        })

        -- Custom mapping for Harpoon: After nvim-tree is loaded
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*",
            callback = function()
                -- Make sure Harpoon uses <C-e>
                vim.keymap.set('n', '<C-e>', function()
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end)

           end,
        })

        vim.keymap.set('n', '<leader>f', ':NvimTreeFindFileToggle<CR>')

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

    end
}
