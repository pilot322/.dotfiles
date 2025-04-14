local keymap = vim.keymap.set

vim.opt.langmap =
	"αa,βb,γg,δd,εe,ζz,ηh,θu,ιi,κk,λl,μm,νn,ξj,οo,πp,ρr,σs,τt,υy,φf,χx,ψc,ωV,ςw,ΑA,ΒB,ΓG,ΔD,ΕE,ΖZ,ΗH,ΘU,ΙI,ΚK,ΛL,ΜM,ΝN,ΞJ,ΟO,ΠP,ΡR,ΣS,ΤT,ΥY,ΦF,ΧX,ΨC,ΩV,ΣW"

vim.g.mapleader = " "
keymap("n", "<leader>pv", vim.cmd.Ex)

keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

keymap("n", "J", "mzJ`z")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

keymap("n", "<leader>vwm", function()
	require("vim-with-me").StartVimWithMe()
end)
keymap("n", "<leader>svwm", function()
	require("vim-with-me").StopVimWithMe()
end)

keymap("x", "<leader>p", [["_dP]])

keymap({ "n", "v" }, "<leader>y", [["+y]])
keymap("n", "<leader>Y", [["+Y]])

keymap({ "n", "v" }, "<leader>d", [["_d]])

keymap("i", "<C-c>", "<Esc>")

keymap("n", "Q", "<nop>")
keymap("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
keymap("n", "<leader>f", vim.lsp.buf.format)

keymap("n", "<C-k>", "<cmd>cnext<CR>zz")
keymap("n", "<C-j>", "<cmd>cprev<CR>zz")
keymap("n", "<leader>k", "<cmd>lnext<CR>zz")
keymap("n", "<leader>j", "<cmd>lprev<CR>zz")

keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

keymap("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>")
keymap("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

keymap("n", "<leader><leader>", function()
	vim.cmd("so")
end)

keymap("n", "<leader>wr", function()
	vim.cmd("set wrap")
end, { noremap = true, silent = true, desc = "Word wrap" })
