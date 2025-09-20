return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  keys = {
    { 
      "<leader>ot", 
      function()
        local line = vim.api.nvim_get_current_line()
        if line:match("^%s*- %[ %]") then
          vim.cmd("s/- \\[ \\]/- [x]/")
        elseif line:match("^%s*- %[x%]") then
          vim.cmd("s/- \\[x\\]/- [ ]/")
        elseif line:match("^%s*- ") then
          vim.cmd("s/- /- [ ] /")
        else
          vim.cmd("normal! I- [ ] ")
        end
      end,
      desc = "Obsidian toggle list item", 
      mode = "n" 
    },
    { 
      "<leader>ot", 
      function()
        vim.cmd("'<,'>s/^\\(\\s*\\)- \\[ \\]/\\1- [x]/e")
        vim.cmd("'<,'>s/^\\(\\s*\\)- \\[x\\]/\\1- [ ]/e")
        vim.cmd("'<,'>s/^\\(\\s*\\)- \\([^\\[]\\)/\\1- [ ] \\2/e")
        vim.cmd("'<,'>s/^\\(\\s*\\)\\([^-]\\)/\\1- [ ] \\2/e")
      end,
      desc = "Obsidian toggle list item", 
      mode = "v" 
    },
  },
  opts = function()
    local workspaces = {}
    local vaults_path = vim.fn.expand("~/Vaults")
    
    if vim.fn.isdirectory(vaults_path) == 1 then
      local handle = vim.loop.fs_scandir(vaults_path)
      if handle then
        while true do
          local name, type = vim.loop.fs_scandir_next(handle)
          if not name then break end
          
          if type == "directory" then
            table.insert(workspaces, {
              name = name:lower(),
              path = "~/Vaults/" .. name .. "/",
            })
          end
        end
      end
    end
    
    return {
      workspaces = workspaces,
    }
  end,
}
