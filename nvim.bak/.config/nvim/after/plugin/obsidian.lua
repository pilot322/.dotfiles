local function is_in_vaults()
    local current_dir = vim.fn.expand('%:p:h')
    return current_dir:match("/Vaults/")
end


if is_in_vaults() then
--  require("obsidian").setup({
--      ui = {
--          enable = false,
--      },
--      workspaces = {
--          {
--              name = "Notes",
--              path = "~/Vaults/obsnotes/",
--          },
--          {
--              name = "INNotes",
--              path = "~/Vaults/INNotes",
--          },
--          {
--              name = "School",
--              path = "~/Vaults/School2.0",
--          },
--          {
--              name = "CodingAcademy",
--              path = "~/Vaults/CodingAcademy",
--          },
--      }
--  })
end

vim.keymap.set('n', '<leader>obsu', ':!git add . && git commit -m "ok" && git push<CR>')
vim.keymap.set('n', '<leader>obsd', ':!git pull<CR>')
vim.keymap.set('n', '<leader>obst', ':!echo test<CR>')

vim.keymap.set("n", "<leader>obt", function()
    require("obsidian").util.toggle_checkbox()
end, { desc = "Toggle Obsidian Todo" })
