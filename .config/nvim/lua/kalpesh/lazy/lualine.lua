return {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    name = "lualine",
    config = function()
        require('lualine').setup()
    end
}
