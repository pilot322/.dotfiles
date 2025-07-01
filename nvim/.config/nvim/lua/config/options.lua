-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.guicursor = ""

vim.opt.conceallevel = 2

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
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.g.snacks_animate = false

vim.g.snacks_explorer = false

vim.opt.showmode = true
vim.opt.cursorline = false
vim.g.autoformat = false

vim.opt.spell = false

-- netrw tricks
vim.g.netrw_rm_cmd = 'trash-put'
vim.g.netrw_rmf_cmd = 'trash-put'
vim.g.netrw_rmdir_cmd = 'trash-put'
