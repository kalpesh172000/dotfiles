return {
    'rmagatti/auto-session',
    name = "AutoSession",
    lazy = false,
    ---enables autocomplete for opts
    ---@module "auto-session"
    opts = {
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        -- log_level = 'debug',
    },
    config = function()
        require('auto-session').setup({
            auto_save_enabled = true,
            auto_restore_enabled = true,
            pre_save_cmds = { "mkview!" },    -- Save marks and folds
            post_restore_cmds = { "silent! loadview" }, -- Restore marks and folds
        })
    end
}
