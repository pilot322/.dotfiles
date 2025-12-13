return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "glimmer" })
      end
      -- Register glimmer parser for handlebars filetype
      vim.treesitter.language.register("glimmer", "handlebars")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        glint = {
          filetypes = { "handlebars", "html.handlebars", "typescript.glimmer", "javascript.glimmer" },
        },
      },
    },
  },
}
