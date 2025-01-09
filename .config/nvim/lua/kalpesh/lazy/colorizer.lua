return {
    "norcalli/nvim-colorizer.lua",
    name = "colorizer",
    config = function()
        vim.opt.termguicolors = true
        require('colorizer').setup({
            '*',             -- Apply to all file types
        }, {
            RGB = true,      -- Enable #RGB hex colors
            RRGGBB = true,   -- Enable #RRGGBB hex colors
            names = false,   -- Disable named colors like "Blue"
            RRGGBBAA = true, -- Enable #RRGGBBAA hex colors
            rgb_fn = true,   -- Enable rgb() and rgba() functions
            hsl_fn = true,   -- Enable hsl() and hsla() functions
            css = true,      -- Enable CSS colors
            css_fn = true,   -- Enable all CSS functions
        })
        vim.api.nvim_set_keymap('n', '<leader>c', ':ColorizerToggle<CR>', { noremap = true, silent = true })
    end
}
