local builtin = require('telescope.builtin')

require("telescope").setup {
    extensions = {
        file_browser = {
        }
    }
}
require("telescope").load_extension "file_browser"

vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })

vim.keymap.set('n', '<leader>pF', function()
    require('telescope.builtin').find_files({
        find_command = { 'find', '.', '-type', 'd', '-not', '-path', '*/\\.*' },
        attach_mappings = function(prompt_bufnr, map)
            local function open_netrw()
                local selection = require('telescope.actions.state').get_selected_entry()
                require('telescope.actions').close(prompt_bufnr)

                -- Close the current netrw buffer if it's open
                local current_buf = vim.api.nvim_get_current_buf()
                local buf_ft = vim.api.nvim_buf_get_option(current_buf, 'filetype')

                if buf_ft == 'netrw' then
                    vim.cmd('bdelete')
                end

                -- Open netrw in the selected directory
                vim.cmd('Explore ' .. selection.value)
            end

            map('i', '<CR>', open_netrw)
            map('n', '<CR>', open_netrw)
            return true
        end
    })
end, { desc = 'Telescope find folder' })

vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Git file search' })
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
