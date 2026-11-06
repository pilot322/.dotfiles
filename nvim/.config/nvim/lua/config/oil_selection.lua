local M = {}
local ns = vim.api.nvim_create_namespace("oil_selection")
local selection
local clipboard

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "Oil selection" })
end

local function entries(buf)
  local result = {}
  for row, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local entry = require("oil").get_entry_on_line(buf, row)
    if entry and entry.id and entry.name ~= ".." then
      result[entry.id] = { row = row, line = line, name = entry.name }
    end
  end
  return result
end

local function redraw()
  if not selection or not vim.api.nvim_buf_is_valid(selection.buf) then
    return
  end
  vim.api.nvim_buf_clear_namespace(selection.buf, ns, 0, -1)
  for id, entry in pairs(entries(selection.buf)) do
    if selection.ids[id] then
      vim.api.nvim_buf_set_extmark(selection.buf, ns, entry.row - 1, 0, {
        line_hl_group = "Visual",
        virt_text = { { clipboard and (clipboard.copy and "  ● copy" or "  ● cut") or "  ●", "DiagnosticInfo" } },
        virt_text_pos = "eol",
      })
    end
  end
end

function M.clear()
  if vim.fn.mode():match("^[vV\022]") then
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    vim.cmd.normal({ esc, bang = true })
  end
  if selection and vim.api.nvim_buf_is_valid(selection.buf) then
    vim.api.nvim_buf_clear_namespace(selection.buf, ns, 0, -1)
  end
  selection, clipboard = nil, nil
end

function M.toggle()
  if clipboard then
    return notify("Paste or clear the pending batch first", vim.log.levels.WARN)
  end
  local buf = vim.api.nvim_get_current_buf()
  if selection and selection.buf ~= buf then
    return notify("Clear the selection before marking another directory", vim.log.levels.WARN)
  end
  selection = selection or { buf = buf, ids = {} }
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local first, last = row, row
  local visual = vim.fn.mode():match("^[vV\022]") ~= nil
  if visual then
    first = vim.fn.getpos("v")[2]
    first, last = math.min(first, row), math.max(first, row)
  end
  local targets, all_marked = {}, true
  for id, entry in pairs(entries(buf)) do
    if entry.row >= first and entry.row <= last then
      targets[#targets + 1] = id
      all_marked = all_marked and selection.ids[id] == true
    end
  end
  for _, id in ipairs(targets) do
    selection.ids[id] = not all_marked or nil
  end
  if visual then
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    vim.cmd.normal({ esc, bang = true })
  end
  redraw()
end

local function stage(copy)
  if clipboard then
    return notify("Paste or clear the pending batch first", vim.log.levels.WARN)
  end
  if not selection or selection.buf ~= vim.api.nvim_get_current_buf() then
    return notify("Mark files with Tab first", vim.log.levels.WARN)
  end
  if vim.bo[selection.buf].modified then
    return notify("Save existing Oil edits before staging marked files", vim.log.levels.WARN)
  end
  local current, batch = entries(selection.buf), {}
  for id in pairs(selection.ids) do
    if not current[id] then
      return notify("Selection is stale; clear it and mark files again", vim.log.levels.WARN)
    end
    batch[#batch + 1] = { id = id, line = current[id].line, name = current[id].name }
  end
  if #batch == 0 then
    return notify("Mark files with Tab first", vim.log.levels.WARN)
  end
  table.sort(batch, function(a, b)
    return current[a.id].row < current[b.id].row
  end)
  batch.copy = copy
  clipboard = batch
  redraw()
  notify(("Staged %d files to %s; navigate and press p"):format(#batch, copy and "copy" or "move"))
end

function M.cut()
  stage(false)
end

function M.copy()
  stage(true)
end

-- Expression mappings return commands so buffer edits happen outside expression-map textlock.
function M.key(key)
  local action
  if key == "p" then
    action = clipboard and "paste"
  elseif clipboard or (selection and next(selection.ids)) then
    action = key == "d" and "cut" or "copy"
  end
  if action then
    return ('<Cmd>lua require("config.oil_selection").%s()<CR>'):format(action)
  end
  return key
end

function M.paste()
  if not clipboard then
    return notify("No pending move or copy", vim.log.levels.WARN)
  end
  local src, dest = selection.buf, vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_loaded(src) then
    M.clear()
    return notify("Source buffer was closed; mark files again. No files were changed.", vim.log.levels.WARN)
  end
  local oil = require("oil")
  if not oil.get_current_dir(dest) or not oil.get_current_dir(src) then
    return notify("Marked files are supported only between local Oil directories", vim.log.levels.WARN)
  end
  if oil.get_current_dir(src) == oil.get_current_dir(dest) then
    return notify("Choose a different destination directory", vim.log.levels.WARN)
  end
  if vim.bo[src].modified or vim.bo[dest].modified then
    return notify("Save existing Oil edits before pasting", vim.log.levels.WARN)
  end
  if not vim.bo[src].modifiable or not vim.bo[dest].modifiable then
    return notify("Oil buffers are not editable right now", vim.log.levels.WARN)
  end
  local current, rows, lines = entries(src), {}, {}
  for _, item in ipairs(clipboard) do
    local entry = current[item.id]
    if not entry or entry.line ~= item.line then
      return notify("Source entries changed; clear the batch and mark files again", vim.log.levels.WARN)
    end
    local source_path = oil.get_current_dir(src) .. item.name .. "/"
    local destination_path = oil.get_current_dir(dest)
    if destination_path:sub(1, #source_path) == source_path then
      return notify("Cannot move or copy a directory into itself: " .. item.name, vim.log.levels.WARN)
    end
    if vim.uv.fs_lstat(oil.get_current_dir(dest) .. item.name) then
      return notify("Destination already contains " .. item.name, vim.log.levels.WARN)
    end
    rows[#rows + 1], lines[#lines + 1] = entry.row, entry.line
  end
  -- Only edit buffers after validating the entire batch. Oil performs the actual move on :w.
  vim.api.nvim_buf_set_lines(dest, -1, -1, false, lines)
  table.sort(rows, function(a, b)
    return a > b
  end)
  if not clipboard.copy then
    for _, row in ipairs(rows) do
      vim.api.nvim_buf_set_lines(src, row - 1, row, false, {})
    end
  end
  local count = #clipboard
  local operation = clipboard.copy and "copies" or "moves"
  M.clear()
  notify(("Pasted %d files; :w to review and apply the %s"):format(count, operation))
end

function M.setup()
  local group = vim.api.nvim_create_augroup("OilSelection", { clear = true })
  vim.api.nvim_create_autocmd("BufUnload", {
    group = group,
    callback = function(event)
      if selection and event.buf == selection.buf then
        M.clear()
        notify("Source buffer closed; cleared file marks and pending batch")
      end
    end,
  })
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
    group = group,
    callback = function(event)
      if selection and event.buf == selection.buf then
        redraw()
      end
    end,
  })
end

return M
