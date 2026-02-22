local M = {}

local function git_root()
  local root = vim.trim(vim.fn.system({ "git", "rev-parse", "--show-toplevel" }))
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return root
end

local function git_cmd(args)
  local root = git_root()
  if not root then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return nil
  end
  local cmd = vim.list_extend({ "git", "-C", root }, args)
  local result = vim.fn.system(cmd)
  return result
end

local function claude_haiku(prompt, context, callback)
  local tmp = vim.fn.tempname()
  local f = io.open(tmp, "w")
  if not f then
    vim.notify("Failed to create temp file", vim.log.levels.ERROR)
    return
  end
  f:write(context)
  f:close()

  local cmd = string.format(
    "claude -p %s --model haiku < %s",
    vim.fn.shellescape(prompt),
    vim.fn.shellescape(tmp)
  )

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      local raw = vim.trim(table.concat(data, "\n"))
      if raw ~= "" then
        vim.schedule(function()
          callback(raw)
        end)
      end
    end,
    on_exit = function(_, code)
      os.remove(tmp)
      if code ~= 0 then
        vim.schedule(function()
          vim.notify("Claude command failed (exit code " .. code .. ")", vim.log.levels.ERROR)
        end)
      end
    end,
  })
end

local function push()
  local root = git_root()
  if not root then
    return
  end
  vim.notify("Pushing...", vim.log.levels.INFO)
  vim.fn.jobstart({ "git", "-C", root, "push" }, {
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          vim.notify("Pushed successfully!", vim.log.levels.INFO)
        else
          vim.notify("Push failed (exit code " .. code .. ")", vim.log.levels.ERROR)
        end
      end)
    end,
  })
end

local function parse_review_buffer(lines)
  local groups = {}
  local current = nil
  local in_files = false

  for _, line in ipairs(lines) do
    if line:match("^#") then
      -- skip comments
    elseif line:match("^%-%-%-") then
      if current and current.message ~= "" and #current.files > 0 then
        table.insert(groups, current)
      end
      current = { files = {}, message = "" }
      in_files = false
    elseif current and line:match("^message:%s*(.+)") then
      current.message = line:match("^message:%s*(.+)")
      in_files = false
    elseif current and line:match("^files:") then
      in_files = true
    elseif current and in_files and line:match("^%- (.+)") then
      table.insert(current.files, line:match("^%- (.+)"))
    end
  end

  if current and current.message ~= "" and #current.files > 0 then
    table.insert(groups, current)
  end

  return groups
end

local function open_review_buffer(groups, on_confirm)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "markdown"

  local lines = {
    "# AI Commit Plan",
    "# Edit messages and file lists below.",
    "# <leader>ac to apply | q to abort",
    "# Delete an entire commit section to skip it.",
    "",
  }

  for i, group in ipairs(groups) do
    table.insert(lines, "--- Commit " .. i .. " ---")
    table.insert(lines, "message: " .. group.message)
    table.insert(lines, "files:")
    for _, file in ipairs(group.files) do
      table.insert(lines, "- " .. file)
    end
    table.insert(lines, "")
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.keymap.set("n", "<leader>ac", function()
    local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local parsed = parse_review_buffer(content)
    vim.api.nvim_buf_delete(buf, { force = true })

    if #parsed == 0 then
      vim.notify("No commits to apply", vim.log.levels.WARN)
      return
    end

    on_confirm(parsed)
  end, { buffer = buf, desc = "Apply commit plan" })

  vim.keymap.set("n", "q", function()
    vim.api.nvim_buf_delete(buf, { force = true })
    vim.notify("Commit plan aborted", vim.log.levels.INFO)
  end, { buffer = buf, desc = "Abort commit plan" })
end

local function apply_groups_and_push(groups)
  local root = git_root()
  if not root then
    return
  end

  for i, group in ipairs(groups) do
    local add_cmd = vim.list_extend({ "git", "-C", root, "add", "--" }, group.files)
    local add_result = vim.fn.system(add_cmd)
    if vim.v.shell_error ~= 0 then
      vim.notify("git add failed for group " .. i .. ": " .. add_result, vim.log.levels.ERROR)
      return
    end

    local commit_result = vim.fn.system({ "git", "-C", root, "commit", "-m", group.message })
    if vim.v.shell_error ~= 0 then
      vim.notify("Commit failed for group " .. i .. ": " .. commit_result, vim.log.levels.ERROR)
      return
    end

    vim.notify(string.format("Committed (%d/%d): %s", i, #groups, group.message), vim.log.levels.INFO)
  end

  push()
end

function M.commit_and_push()
  local root = git_root()
  if not root then
    return
  end

  local diff = vim.fn.system({ "git", "-C", root, "diff", "--cached" })
  if vim.v.shell_error ~= 0 or diff:match("^%s*$") then
    vim.notify("No staged changes to commit", vim.log.levels.WARN)
    return
  end

  vim.notify("Generating commit message with Claude Haiku...", vim.log.levels.INFO)

  local prompt = "Read the following staged git diff and generate a single commit message following the Conventional Commits specification "
    .. "(types: feat, fix, chore, refactor, docs, style, perf, test, build, ci). "
    .. "Use a scope in parentheses when appropriate. "
    .. "ONLY return the commit message text. No markdown, no backticks, no quotes, no explanation."

  claude_haiku(prompt, diff, function(msg)
    vim.notify("Committing: " .. msg, vim.log.levels.INFO)
    local result = vim.fn.system({ "git", "-C", root, "commit", "-m", msg })
    if vim.v.shell_error ~= 0 then
      vim.notify("Commit failed: " .. result, vim.log.levels.ERROR)
      return
    end
    push()
  end)
end

function M.group_commit_and_push()
  local root = git_root()
  if not root then
    return
  end

  local status = vim.fn.system({ "git", "-C", root, "status", "--porcelain" })
  if vim.v.shell_error ~= 0 or status:match("^%s*$") then
    vim.notify("No uncommitted changes found", vim.log.levels.WARN)
    return
  end

  -- Extract exact file paths from git status to prevent hallucinated paths
  local valid_files = {}
  for line in status:gmatch("[^\n]+") do
    -- porcelain format: XY filename  or  XY old -> new (renames)
    local file = line:sub(4)
    local renamed = file:match("^.+ -> (.+)$")
    table.insert(valid_files, renamed or file)
  end

  local diff = vim.fn.system({ "git", "-C", root, "diff" })

  vim.notify("Grouping changes with Claude Haiku...", vim.log.levels.INFO)

  local file_list = table.concat(valid_files, "\n")
  local context = "EXACT file paths (you MUST only use these):\n"
    .. file_list
    .. "\n\nGit status:\n"
    .. status
    .. "\n\nDiff of tracked files:\n"
    .. diff

  local prompt = "Given the following git status and diff, group the files into logical commits. "
    .. "Each commit must follow the Conventional Commits specification "
    .. "(types: feat, fix, chore, refactor, docs, style, perf, test, build, ci). "
    .. "Use a scope in parentheses when appropriate. "
    .. "CRITICAL: In the files array, use ONLY the exact file paths from the EXACT file paths list. Do NOT modify, shorten, or invent paths. "
    .. "Return ONLY a JSON array with no markdown and no backticks. "
    .. 'Format: [{"files":["path/to/file"],"message":"type(scope): description"}]'

  claude_haiku(prompt, context, function(raw)
    -- Extract JSON array from response: find first [ to last ]
    local json_start = raw:find("%[")
    local json_end = raw:reverse():find("%]")
    if not json_start or not json_end then
      vim.notify("No JSON array found in response:\n" .. raw, vim.log.levels.ERROR)
      return
    end
    local json_str = raw:sub(json_start, #raw - json_end + 1)

    local ok, groups = pcall(vim.json.decode, json_str)
    if not ok or type(groups) ~= "table" or #groups == 0 then
      vim.notify("Failed to parse commit groups:\n" .. json_str, vim.log.levels.ERROR)
      return
    end

    -- Validate and fix paths: drop any files not in the valid set
    local valid_set = {}
    for _, vf in ipairs(valid_files) do
      valid_set[vf] = true
    end

    for _, group in ipairs(groups) do
      if group.files then
        local cleaned = {}
        for _, file in ipairs(group.files) do
          if valid_set[file] then
            table.insert(cleaned, file)
          else
            vim.notify("Dropped invalid path from plan: " .. file, vim.log.levels.WARN)
          end
        end
        group.files = cleaned
      end
    end

    -- Remove groups that ended up with no valid files
    local filtered = {}
    for _, group in ipairs(groups) do
      if group.files and #group.files > 0 and group.message then
        table.insert(filtered, group)
      end
    end

    if #filtered == 0 then
      vim.notify("No valid commit groups after path validation", vim.log.levels.ERROR)
      return
    end

    open_review_buffer(filtered, apply_groups_and_push)
  end)
end

return M
