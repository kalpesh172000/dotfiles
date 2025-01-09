return {
    "windwp/nvim-ts-autotag",
    dependencies = { "treesitter" },
    config = function()
        require("nvim-ts-autotag").setup({
            filetypes = { "html", "xml", "javascriptreact", "typescriptreact"},
        })
    end,
}
