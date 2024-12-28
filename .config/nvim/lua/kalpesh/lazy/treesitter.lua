return {
    -- Treesitter plugin
    {
        "nvim-treesitter/nvim-treesitter",
        name = "treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "vimdoc", "javascript", "typescript", "c", "lua", "rust",
                    "jsdoc", "bash", "cpp", "python" -- Add any languages you need
                },
                sync_install = false,
                auto_install = true,
                indent = { enable = true },
                highlight = { enable = true },
                rainbow = {
                    enable = true,         -- Enables rainbow brackets
                    extended_mode = true,  -- Highlight brackets, parentheses, and more
                    max_file_lines = 1000, -- Disable for large files
                },
            })

            local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            treesitter_parser_config.templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "master",
                },
            }
        end,
    },
    -- Rainbow brackets plugin
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = "BufRead", -- Load on buffer read for performance
        config = function()
            -- This module contains a number of default definitions
            local rainbow_delimiters = require 'rainbow-delimiters'

            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = rainbow_delimiters.strategy['global'],
                    vim = rainbow_delimiters.strategy['local'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    lua = 'rainbow-blocks',
                },
                priority = {
                    [''] = 110,
                    lua = 210,
                },
                highlight = {
--                    'RainbowDelimiterRed',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                },
            }
        end
    },
}
