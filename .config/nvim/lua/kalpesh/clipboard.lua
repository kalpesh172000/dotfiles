--[[ 
vim.opt.clipboard:append("unnamedplus")
vim.g.clipboard = {
    name = "win32yank",
    copy = {
        ["+"] = "/mnt/c/Windows/win32yank.exe -i",
        ["*"] = "/mnt/c/Windows/win32yank.exe -i",
    },
    paste = {
        ["+"] = "/mnt/c/Windows/win32yank.exe -o",
        ["*"] = "/mnt/c/Windows/win32yank.exe -o",
    },
    cache_enabled = 0,
}
]]
vim.opt.clipboard = "unnamedplus"
