vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "plaintex", "typst", "gitcommit" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

function NetrwTrash()
  -- Get the filename/dirname from the line under the cursor
  local line = vim.fn.getline('.')
  if not line or line == '' or line == '../' then
    print('Trash cancelled.')
    return
  end

  -- CORRECTED: Build the full path, ensuring there is a '/' separator
  local current_dir = vim.fn.expand('%:p')
  local filepath = current_dir .. '/' .. line

  -- Use 'trash' for macOS, 'trash-put' for Linux. Change if needed.
  local trash_cmd = 'trash-put ' .. vim.fn.shellescape(filepath)

  -- Get a single character for confirmation
  local function get_user_input_char()
    local c = vim.fn.getchar()
    return vim.fn.nr2char(c)
  end

  print('Trash ' .. filepath .. ' ? (y/n)')

  -- Check for 'y' or 'Y' to confirm
  if get_user_input_char():lower():match('^y') then
    -- Run the trash command asynchronously
    vim.fn.jobstart(trash_cmd, {
      detach = true,
      on_exit = function()
        print('"' .. line .. '" moved to Trash.')
        -- Refresh the netrw buffer to show the change
        vim.cmd('edit')
      end,
    })
  else
    print('Trash cancelled.')
  end
end

-- Map the 'D' key in netrw buffers to our custom trash function
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  desc = 'Map D to custom trash function for netrw',
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', 'D', '<Cmd>lua NetrwTrash()<CR>', { noremap = true, silent = true })
  end,
})

