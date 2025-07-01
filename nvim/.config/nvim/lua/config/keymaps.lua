-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.opt.langmap =
  "αa,βb,γg,δd,εe,ζz,ηh,θu,ιi,κk,λl,μm,νn,ξj,οo,πp,ρr,σs,τt,υy,φf,χx,ψc,ωV,ςw,ΑA,ΒB,ΓG,ΔD,ΕE,ΖZ,ΗH,ΘU,ΙI,ΚK,ΛL,ΜM,ΝN,ΞJ,ΟO,ΠP,ΡR,ΣS,ΤT,ΥY,ΦF,ΧX,ΨC,ΩV"

vim.g.mapleader = " "

vim.keymap.set("i", "jj", "<Esc>")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
  require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
  require("vim-with-me").StopVimWithMe()
end)

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>")
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

vim.keymap.set("n", "<leader>wr", function()
  vim.opt.wrap = not vim.opt.wrap:get()
end, { noremap = true, silent = true, desc = "Toggle word wrap" })

vim.keymap.set("n", "<leader>bs", function()
  local current = vim.opt.showtabline:get()
  if current == 0 then
    vim.opt.showtabline = 2
    vim.g.bufferline_enabled = true
  else
    vim.opt.showtabline = 0
    vim.g.bufferline_enabled = false
  end
end)

vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("BufferlineState", { clear = true }),
  callback = function()
    if vim.g.bufferline_enabled == false then
      vim.o.showtabline = 0
    end
  end,
})

vim.keymap.set("n", "<leader>f.e", ":e .env<CR>", { desc = "Open .env file" })
vim.keymap.set("n", "<leader>f.g", ":e .gitignore<CR>", { desc = "Open .gitignore file" })
