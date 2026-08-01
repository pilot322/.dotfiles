return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  config = function()
    require("diffview").setup()
  end,
  keys = {
    {
      "<leader>gd",
      function()
        local view = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD@{upstream}")[1]
        if view and view ~= "" and not view:match("fatal") then
          view = view:gsub("origin/", "")
          vim.cmd("DiffviewClose")
          vim.cmd("DiffviewOpen " .. view)
        else
          vim.cmd("DiffviewOpen")
        end
      end,
      desc = "DiffviewOpen (against upstream)",
    },
    {
      "<leader>gD",
      "<cmd>DiffviewClose<cr>",
      desc = "DiffviewClose",
    },
  },
}
