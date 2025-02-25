-- Require null-ls
local null_ls = require("null-ls")

-- Set up PHPCS for diagnostics and PHP-CS-Fixer for formatting
null_ls.setup({
  sources = {
    -- Linter: PHPCS (diagnostics)
    null_ls.builtins.diagnostics.phpcs.with({
      args = { "--standard=PSR12", "--report=json", "$FILENAME" },
      -- Uncomment and adjust if Mason installs the binary in a non-standard location:
      -- command = vim.fn.stdpath("data") .. "/mason/bin/phpcs",
    }),
    -- Formatter: PHP-CS-Fixer
    null_ls.builtins.formatting.phpcsfixer.with({
      -- Uncomment and adjust if needed:
      -- command = vim.fn.stdpath("data") .. "/mason/bin/php-cs-fixer",
    }),
  },
  -- Optionally, autoformat on save:
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_augroup("LspFormatting", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = "LspFormatting",
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end,
})

