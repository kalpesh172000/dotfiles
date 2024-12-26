return {
    'rmagatti/auto-session',
    name = "AutoSession",
    lazy = false,
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        -- log_level = 'debug',
    }
}
