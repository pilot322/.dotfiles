-- Add .handlebars extension to filetype detection
vim.filetype.add({
  extension = {
    handlebars = "handlebars",
  },
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "html" })
      end
      -- Use html parser for handlebars filetype (glimmer not available)
      vim.treesitter.language.register("html", "handlebars")
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
