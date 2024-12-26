vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set('i', 'kj', '<Esc>', { desc = 'Exit insert mode' })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- greatest remap ever
-- paste operaton presert what was pasted so it can be pasted again 
vim.keymap.set("x", "<leader>p", [["_dP]])


-- next greatest remap ever : asbjornHaland
--vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
--vim.keymap.set("n", "<leader>Y", [["+Y]])

--this delete operation not copy the deleted text in clipboard preserving
--previous clipboard
vim.keymap.set({"n", "v"}, "<leader>d", "\"_d")
vim.keymap.set("n", "Q", "<nop>") --ysa<" 

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

--cursor movment through split screen 
vim.keymap.set('n', '<M-h>', '<C-w>h', { desc = 'Move to the left split' }) -- Alt+h
vim.keymap.set('n', '<M-j>', '<C-w>j', { desc = 'Move to the split below' }) -- Alt+j
vim.keymap.set('n', '<M-k>', '<C-w>k', { desc = 'Move to the split above' }) -- Alt+k
vim.keymap.set('n', '<M-l>', '<C-w>l', { desc = 'Move to the right split' }) -- Alt+l

