return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      enable = true,
      max_lines = 0, -- Show as many context lines as possible
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20, -- Show multiline context if parent is bigger than this
      trim_scope = "outer", -- Which context lines to discard if max_lines is exceeded
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      zindex = 20,
    },
  },
}
