return {
    "rafamadriz/friendly-snippets",
    name = "friendly snippets",
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
    end
}
