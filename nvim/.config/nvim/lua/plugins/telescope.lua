return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- This is where you would add custom config if you wanted
      -- For now, we'll just load it with defaults
      require("telescope").setup({})
    end,

    keys = {
      {
        "<leader>tlds",
        ":Telescope lsp_document_symbols<CR>",
        desc = "Obsidian toggle list item",
        mode = "n",
      },
    },
  },
}
