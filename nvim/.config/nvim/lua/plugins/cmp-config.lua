return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      -- Make sure Enter only confirms if you manually selected an item,
      -- otherwise it inserts a newline.
      opts.mapping["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert, -- Use Insert instead of Replace if needed
        select = false, -- Requires you to explicitly select or move to an item
      })

      -- Optional: Disable preselection entirely if you prefer
      opts.preselect = cmp.PreselectMode.None

      return opts
    end,
  },
}
