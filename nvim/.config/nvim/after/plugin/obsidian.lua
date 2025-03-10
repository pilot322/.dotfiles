local function is_in_vaults()
    local current_dir = vim.fn.expand('%:p:h')
    return current_dir:match("/Vaults/")
end

if is_in_vaults() then
    vim.opt.conceallevel = 1
    require("obsidian").setup({
        ui = {
            enable = true,
        },
        workspaces = {
            {
                name = "Notes",
                path = "~/Documents/Vaults/Notes/",
            },
            {
                name = "INNotes",
                path = "~/Documents/Vaults/INNotes",
            },
            {
                name = "School",
                path = "~/Documents/Vaults/School2.0",
            },
            {
                name = "CodingAcademy",
                path = "~/Documents/Vaults/CodingAcademy",
            },
        }
    })
end

vim.keymap.set('n', '<leader>obsu', ':!git add . && git commit -m "ok" && git push<CR>')
vim.keymap.set('n', '<leader>obsd', ':!git pull<CR>')
vim.keymap.set('n', '<leader>obst', ':!echo test<CR>')

vim.keymap.set("n", "<leader>obt", function()
    require("obsidian").util.toggle_checkbox()
end, { desc = "Toggle Obsidian Todo" })

