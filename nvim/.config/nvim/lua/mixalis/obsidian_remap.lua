--vim.keymap.set('n', '<leader>obss', function()
    --local cwd = vim.fn.getcwd()  -- Get the current working directory
    --local folder_name = vim.fn.fnamemodify(cwd, ':t')  -- Extract the folder name
--
    --local command = string.format('!rclone bisync --drive-import-formats=xlsx -v %s ObsidianNotes:%s', cwd, folder_name)
    --vim.cmd(command)
--end, { noremap = true, silent = true, desc = 'Run terminal command with current directory' })
--
--vim.keymap.set('n', '<leader>obsf', function()
    --local cwd = vim.fn.getcwd()  -- Get the current working directory
    --local folder_name = vim.fn.fnamemodify(cwd, ':t')  -- Extract the folder name
--
    --local command = string.format('!rclone sync -v %s ObsidianNotes:%s', cwd, folder_name)
    --vim.cmd(command)
--end, { noremap = true, silent = true, desc = 'Run terminal command with current directory' })
--
--vim.keymap.set('n', '<leader>obsr', function()
    --local cwd = vim.fn.getcwd()  -- Get the current working directory
    --local folder_name = vim.fn.fnamemodify(cwd, ':t')  -- Extract the folder name
--
    --local command = string.format('!rclone bisync --resync --drive-import-formats=xlsx -v %s ObsidianNotes:%s', cwd, folder_name)
    --vim.cmd(command)
--end, { noremap = true, silent = true, desc = 'Run terminal command with current directory' })

vim.keymap.set('n', '<leader>obsu', ':!git add . && git commit -m "ok" && git push<CR>')
vim.keymap.set('n', '<leader>obsd', ':!git pull<CR>')
vim.keymap.set('n', '<leader>obst', ':!echo test<CR>')

vim.keymap.set("n", "<leader>obt", function()
    require("obsidian").toggle_todo()
end, { desc = "Toggle Obsidian Todo" })
