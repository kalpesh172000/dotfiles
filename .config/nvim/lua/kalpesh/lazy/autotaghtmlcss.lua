return {
    "windwp/nvim-ts-autotag",
    dependencies = { "treesitter" },
    config = function()
        require("nvim-ts-autotag").setup()
    end,
}
