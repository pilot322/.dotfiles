return {
  {
    "neovim/nvim-lspconfig",

    -- This section configures the servers. It is left as you had it.
    opts = {
      autoformat = false,
      servers = {
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true, -- let ruff handle this
            },
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace", -- indexes whole workspace, not just open files
                typeCheckingMode = "basic",
                diagnosticSeverityOverrides = {
                  reportUndefinedVariable = "error", -- needed for import code actions
                },
              },
            },
          },
        },
        ruff = {
          settings = {
            interpreter = { vim.fn.exepath("python3") or vim.fn.exepath("python") },
          },
        },
      },
    },

    -- This section sets global keymaps for when the plugin is loaded.
    keys = {
      {
        "<leader>lc",
        vim.lsp.buf.rename,
        desc = "LSP Rename",
        mode = "n",
      },
    },

    -- -- This function runs AFTER the plugin is loaded and configured.
    -- -- This is where we safely add our buffer-local keymaps without conflict.
    -- config = function()
    --   vim.api.nvim_create_autocmd("LspAttach", {
    --     group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    --     callback = function(ev)
    --       -- Keymaps are created ONLY in the buffer the LSP attaches to.
    --       local bufnr = ev.buf
    --
    --       vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
    --       vim.keymap.set("n", "<leader>lsh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
    --     end,
    --   })
    -- end,
  },
}
