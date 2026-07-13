vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "plaintex", "typst", "gitcommit" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- Auto-reload files changed on disk (e.g. by AI coding tools) without manual :e
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermClose", "TermLeave" }, {
  desc = "Check for external file changes and reload the buffer",
  callback = function()
    -- Skip command-line window and unnamed buffers
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Notify when a file was reloaded from disk
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  desc = "Notify when a buffer is reloaded due to an external change",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
  end,
})

-- Poll fugitive status every 2s, but only reload when `git status` output actually
-- changes -- a blind reload rewrites the buffer every tick and causes flashing.
do
  -- Guard against duplicate timers when this file is re-sourced
  if _G.__fugitive_poll_timer then
    pcall(function()
      _G.__fugitive_poll_timer:stop()
      _G.__fugitive_poll_timer:close()
    end)
  end

  local uv = vim.uv or vim.loop
  local timer = uv.new_timer()
  _G.__fugitive_poll_timer = timer
  local last_status = {}

  local function visible_fugitive_buf()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "fugitive" then
        return buf
      end
    end
  end

  local function git_status_cwd(git_dir)
    local gitdir_file = git_dir .. "/gitdir"
    if vim.fn.filereadable(gitdir_file) == 1 then
      local ok, lines = pcall(vim.fn.readfile, gitdir_file, "", 1)
      local worktree_git_file = ok and lines[1]
      if worktree_git_file and worktree_git_file ~= "" then
        if not worktree_git_file:match("^/") then
          worktree_git_file = vim.fs.normalize(git_dir .. "/" .. worktree_git_file)
        end

        local worktree = vim.fn.fnamemodify(worktree_git_file, ":h")
        if vim.fn.isdirectory(worktree) == 1 then
          return worktree
        end
      end
    end

    return vim.fn.fnamemodify(git_dir, ":h")
  end

  timer:start(
    2000,
    2000,
    vim.schedule_wrap(function()
      local buf = visible_fugitive_buf()
      if not buf or vim.fn.exists("*FugitiveGitDir") ~= 1 then
        return
      end
      local git_dir = vim.fn.FugitiveGitDir(buf)
      if git_dir == "" then
        return
      end
      local cwd = git_status_cwd(git_dir)
      vim.system(
        { "git", "status", "--porcelain=v1", "-b" },
        { cwd = cwd, text = true },
        vim.schedule_wrap(function(out)
          if out.code ~= 0 then
            return
          end
          local key = tostring(buf)
          if last_status[key] == out.stdout then
            return -- nothing changed, skip reload (no flash)
          end
          local first = last_status[key] == nil
          last_status[key] = out.stdout
          if first then
            return -- prime the cache without an initial reload
          end
          if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "fugitive" then
            vim.api.nvim_buf_call(buf, function()
              if vim.fn.exists("*fugitive#DidChange") == 1 then
                vim.fn["fugitive#DidChange"](0)
              end
            end)
          end
        end)
      )
    end)
  )
end

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
