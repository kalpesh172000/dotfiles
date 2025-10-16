vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

--vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

--vim.opt.fileformat = "unix"
--vim.opt.list = false
vim.opt.filetype = "on"

-- Enable rainbow brackets plugin
vim.g.rainbow_active = 1

-- Optionally ensure 'syntax on' is enabled
vim.cmd("syntax on")

-- Show statusline only once, at the very bottom
vim.opt.laststatus = 3

-- Don’t reserve a command line when not needed
vim.opt.cmdheight = 0

vim.opt.showcmd = false
vim.opt.showmode = false
