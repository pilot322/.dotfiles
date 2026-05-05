return {
  "obsidian-nvim/obsidian.nvim",
  lazy = true,
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/Vaults/*.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/Vaults/*.md",
    "BufReadPre " .. vim.fn.expand("~") .. "/Vaults/**/*.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/Vaults/**/*.md",
  },
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
      mode = "n",
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
      mode = "v",
    },
    {
      "<leader>on",
      function()
        local a = vim.fn.getpos("v")
        local b = vim.fn.getpos(".")
        if a[2] ~= b[2] then
          vim.notify("Selection must be on a single line", vim.log.levels.ERROR)
          return
        end
        local s_col, e_col = a[3], b[3]
        if s_col > e_col then
          s_col, e_col = e_col, s_col
        end
        local src_buf = vim.api.nvim_get_current_buf()
        local src_row = a[2] - 1
        local line = vim.fn.getline(a[2])
        e_col = math.min(e_col, #line)
        local raw = line:sub(s_col, e_col)
        local selected = vim.trim(raw)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        if selected == "" then
          vim.notify("No text selected", vim.log.levels.ERROR)
          return
        end
        local sel_start_col = s_col - 1
        local sel_end_col = e_col

        local current_file = vim.api.nvim_buf_get_name(0)
        local dir = current_file ~= "" and vim.fn.fnamemodify(current_file, ":h") or vim.fn.getcwd()
        local sanitize = function(s)
          return (s:lower():gsub("%s+", "_"):gsub("[^%w_%-]", ""):gsub("_+", "_"):gsub("^_+", ""):gsub("_+$", ""))
        end
        local filename = sanitize(selected)
        if filename == "" then
          vim.notify("Selection produced an empty filename after sanitization", vim.log.levels.ERROR)
          return
        end
        local default_path = dir .. "/" .. filename .. ".md"
        local title = selected

        local buf = vim.api.nvim_create_buf(false, true)
        vim.cmd("topleft vsplit")
        vim.api.nvim_set_current_buf(buf)
        vim.bo[buf].buftype = "nofile"
        vim.bo[buf].bufhidden = "wipe"
        vim.bo[buf].swapfile = false
        vim.bo[buf].filetype = "markdown"

        local lines = {
          "# New Obsidian Note",
          "# Edit the full path below.",
          "# <leader>ac to create | :q to abort",
          "",
          default_path,
        }
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

        local confirmed = false
        vim.api.nvim_create_autocmd("BufWipeout", {
          buffer = buf,
          once = true,
          callback = function()
            if not confirmed then
              vim.notify("Note creation aborted", vim.log.levels.INFO)
            end
          end,
        })

        vim.keymap.set("n", "<leader>ac", function()
          confirmed = true
          local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          local path
          for _, l in ipairs(content) do
            if not l:match("^#") and l:match("%S") then
              path = vim.trim(l)
              break
            end
          end
          vim.api.nvim_buf_delete(buf, { force = true })

          if not path or path == "" then
            vim.notify("No path provided", vim.log.levels.WARN)
            return
          end

          local expanded = vim.fn.expand(path)
          if vim.fn.filereadable(expanded) == 1 then
            vim.notify("File already exists: " .. expanded, vim.log.levels.ERROR)
            return
          end

          local parent = vim.fn.fnamemodify(expanded, ":h")
          vim.fn.mkdir(parent, "p")

          local id = sanitize(vim.fn.fnamemodify(expanded, ":t:r"))
          if id == "" then
            vim.notify("Filename produced an empty id after sanitization", vim.log.levels.ERROR)
            return
          end
          local note = {
            "---",
            "id: " .. id,
            "aliases:",
            "  - " .. title,
            "tags: []",
            "---",
            "",
            "# " .. title,
            "",
          }
          vim.fn.writefile(note, expanded)

          if vim.api.nvim_buf_is_valid(src_buf) then
            local link = "[[" .. id .. "|" .. selected .. "]]"
            vim.api.nvim_buf_set_text(src_buf, src_row, sel_start_col, src_row, sel_end_col, { link })
          end

          vim.cmd("edit " .. vim.fn.fnameescape(expanded))
        end, { buffer = buf, desc = "Create note" })
      end,
      desc = "Obsidian new note from selection",
      mode = "v",
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
          if not name then
            break
          end

          if type == "directory" then
            table.insert(workspaces, {
              name = name:lower(),
              path = "~/Vaults/" .. name .. "/",
              strict = true,
            })
          end
        end
      end
    end

    return {
      workspaces = workspaces,
      legacy_commands = false,
      completion = {
        nvim_cmp = false,
        blink = true,
        min_chars = 2,
      },
    }
  end,
}
