return {
  "tpope/vim-surround",
  init = function()
    vim.g.surround_no_mappings = 0 -- Ensure mappings are created
  end,
}
