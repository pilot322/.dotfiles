vim.keymap.set('n', '<leader>obss', function()
    local cwd = vim.fn.getcwd()  -- Get the current working directory
    local folder_name = vim.fn.fnamemodify(cwd, ':t')  -- Extract the folder name

    local command = string.format('!rclone bisync --drive-import-formats=xlsx -v %s ObsidianNotes:%s', cwd, folder_name)
    vim.cmd(command)
end, { noremap = true, silent = true, desc = 'Run terminal command with current directory' })

vim.keymap.set('n', '<leader>obsf', function()
    local cwd = vim.fn.getcwd()  -- Get the current working directory
    local folder_name = vim.fn.fnamemodify(cwd, ':t')  -- Extract the folder name

    local command = string.format('!rclone sync -v %s ObsidianNotes:%s', cwd, folder_name)
    vim.cmd(command)
end, { noremap = true, silent = true, desc = 'Run terminal command with current directory' })

vim.keymap.set('n', '<leader>obsr', function()
    local cwd = vim.fn.getcwd()  -- Get the current working directory
    local folder_name = vim.fn.fnamemodify(cwd, ':t')  -- Extract the folder name

    local command = string.format('!rclone bisync --resync --drive-import-formats=xlsx -v %s ObsidianNotes:%s', cwd, folder_name)
    vim.cmd(command)
end, { noremap = true, silent = true, desc = 'Run terminal command with current directory' })

