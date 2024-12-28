function ColorMyPencil(color)
    color = color or "onedark"
    vim.cmd.colorscheme(color)

    -- Set background for common highlight groups to "none" for transparency
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    -- Keep the status line and vertical splits with a visible border color
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "#2E2E2E", fg = "#FFFFFF" })
    vim.api.nvim_set_hl(0, "VertSplit", { bg = "none", fg = "#FFFFFF" })
    vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none", fg = "#FFFFFF" })

    -- Keep the cursor line number visible
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "none", underline = false })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none", fg = "#FFD700", bold = true })

    -- Popup menu transparency with borders
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "none", fg = "#FFFFFF" })
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#444444", fg = "#FFFFFF" }) -- Popup menu selection
end

return {
    {
        "navarasu/onedark.nvim",
        name = "onedark",
        config = function()
            -- Load OneDark and configure it
            require('onedark').setup {
                style = 'cool',               -- Default theme style
                transparent = true,           -- Show/hide background
                term_colors = true,           -- Change terminal color as per theme style
                ending_tildes = false,        -- Hide end-of-buffer tildes
                cmp_itemkind_reverse = false, -- Reverse item kind highlights in cmp menu

                -- Toggle theme style (optional)
                toggle_style_key = nil, -- Set a keybind to toggle styles
                toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' },

                -- Code style configuration
                code_style = {
                    comments = 'italic',
                    keywords = 'none',
                    functions = 'none',
                    strings = 'none',
                    variables = 'none'
                },

                -- Lualine options
                lualine = { transparent = false },

                -- Custom Highlights (optional)
                colors = {},
                highlights = {},

                -- Plugin diagnostics options
                diagnostics = {
                    darker = true,
                    undercurl = true,
                    background = true,
                },
            }

            -- Call ColorMyPencil after OneDark is loaded
            ColorMyPencil()
        end
    },
}
