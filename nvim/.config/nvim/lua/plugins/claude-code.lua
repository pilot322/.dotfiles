return {
    enabled=false,
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup({
      window = {
        split_ratio = 0.5, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
        position = "rightbelow hsplit", -- Position of the window: "botright", "topleft", "vertical", "rightbelow vsplit", etc.
        enter_insert = false, -- Whether to enter insert mode when opening Claude Code
        hide_numbers = true, -- Hide line numbers in the terminal window
        hide_signcolumn = true, -- Hide the sign column in the terminal window
      },
    })
  end,
}
