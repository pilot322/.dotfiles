return {
  "tpope/vim-fugitive",
  keys = {
    {
      "<leader>gs",
      function()
        -- Get the current file path before switching
        local current_file = vim.fn.expand("%:.") -- relative path

        -- Check if fugitive buffer is already open
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.bo[buf].filetype
          if ft == "fugitive" then
            -- Close the fugitive window
            vim.api.nvim_win_close(win, false)
            return
          end
        end

        -- Open fugitive
        vim.cmd("topleft vertical Git")
        vim.cmd("vertical resize 40")

        -- Try to jump to the current file if it's in the status
        if current_file ~= "" then
          vim.defer_fn(function()
            -- Search for the file in the buffer
            local found = vim.fn.search(vim.fn.escape(current_file, "/\\"), "w")
            if found == 0 then
              -- Try just the filename if full path not found
              local filename = vim.fn.fnamemodify(current_file, ":t")
              vim.fn.search(vim.fn.escape(filename, "/\\"), "w")
            end
          end, 10)
        end
      end,
      desc = "Toggle Git status (jump to current file)",
    },
  },
}
