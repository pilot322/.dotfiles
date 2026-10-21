return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      enable = true,
      max_lines = 3, -- Limit the total number of pinned context lines
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 1, -- Show only the first line of multiline declarations
      trim_scope = "outer", -- Which context lines to discard if max_lines is exceeded
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      zindex = 20,
    },
  },
}
