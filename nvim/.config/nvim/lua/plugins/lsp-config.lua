return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      autoformat = false,
      servers = {
        -- Explicitly tell ruff-lsp which python to use
        ruff = {
          settings = {
            interpreter = { vim.fn.exepath("python3") or vim.fn.exepath("python") },
          },
        },
      },
    },

    keys = {
      {
        "<leader>lc",
        vim.lsp.buf.rename,
        desc = "LSP Rename",
        mode = "n",
      },
    },
  },
}
