return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = false,
      },
      dashboard = {
        preset = {
          pick = function(cmd, opts)
            return LazyVim.pick(cmd, opts)()
          end,
          header = [[
888          888          d8b               
888          888          Y8P               
888          888                            
888  .d88b.  888 888  888 888 88888b.d88b.  
888 d88""88b 888 888  888 888 888 "888 "88b 
888 888  888 888 Y88  88P 888 888  888  888 
888 Y88..88P 888  Y8bd8P  888 888  888  888 
888  "Y88P"  888   Y88P   888 888  888  888 
]],
        },
      },
    },
  },
}
