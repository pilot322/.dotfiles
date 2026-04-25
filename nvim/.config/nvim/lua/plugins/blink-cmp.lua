return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.enabled = function()
      return vim.g.blink_cmp_enabled ~= false and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
    end

    opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
      preset = "default",
      ["<Tab>"] = {},
      ["<S-Tab>"] = {},
      ["<CR>"] = { "accept", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
    })

    -- Add project-local .vscode snippets path
    opts.sources = opts.sources or {}
    opts.sources.providers = opts.sources.providers or {}
    opts.sources.providers.snippets = opts.sources.providers.snippets or {}
    opts.sources.providers.snippets.opts = opts.sources.providers.snippets.opts or {}
    opts.sources.providers.snippets.opts.search_paths = opts.sources.providers.snippets.opts.search_paths or {}

    table.insert(opts.sources.providers.snippets.opts.search_paths, vim.fn.getcwd() .. "/.vscode")

    -- 99 rules completion provider
    -- opts.sources.providers["99"] = {
    --   module = "custom.blink-99",
    --   name = "99",
    -- }

    -- opts.sources.default = opts.sources.default or {}
    -- table.insert(opts.sources.default, "99")

    return opts
  end,
}
