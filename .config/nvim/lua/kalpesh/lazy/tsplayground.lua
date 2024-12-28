return {
    {
        "nvim-treesitter/playground",
        name = "treesitter playground",
        after = "nvim-treesitter", -- Ensure it loads after nvim-treesitter
        config = function()
            -- Optional: Configure Treesitter playground
            require("nvim-treesitter.configs").setup({
                playground = {
                    enable = true,
                    updatetime = 25, -- Debounced time for highlighting
                    persist_queries = false, -- Keep queries after quitting
                }
            })
        end
    }
}
