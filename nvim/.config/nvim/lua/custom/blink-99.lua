local helpers = require("99.extensions.agents.helpers")

local source = {}
source.__index = source

function source.new(opts)
  local self = setmetatable({}, source)
  self.custom_rules = vim.g.nn_custom_rules or {}
  self._items = nil
  return self
end

function source:get_trigger_characters()
  return { "@" }
end

function source:_build_items()
  if self._items then
    return self._items
  end

  local items = {}
  for _, dir in ipairs(self.custom_rules) do
    local ok, rules = pcall(helpers.ls, dir)
    if ok and rules then
      for _, rule in ipairs(rules) do
        local doc_lines = {}
        local head_ok, head = pcall(helpers.head, rule.path)
        if head_ok and head then
          doc_lines = head
        end

        table.insert(items, {
          label = "@" .. rule.name,
          insertText = "@" .. rule.name,
          filterText = "@" .. rule.name,
          kind = 17, -- File
          detail = rule.path,
          documentation = {
            kind = "markdown",
            value = table.concat(doc_lines, "\n"),
          },
        })
      end
    end
  end

  self._items = items
  return self._items
end

function source:get_completions(ctx, cb)
  cb({
    is_incomplete_forward = false,
    is_incomplete_backward = false,
    items = self:_build_items(),
  })
end

return source
