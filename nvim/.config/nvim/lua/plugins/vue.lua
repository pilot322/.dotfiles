-- lua/plugins/vue.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Explicitly disable Hybrid Mode.
        -- This forces Volar to handle the entire Vue file itself,
        -- preventing the TypeScript server from incorrectly parsing the template.
        volar = {
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
        },

        -- We remove our previous custom vtsls configuration.
        -- LazyVim's default setup for vtsls will handle regular.ts files,
        -- while the setting above ensures Volar handles.vue files correctly.
        vtsls = {},
      },
    },
  },
  {
    -- Ensure treesitter is also configured for vue for proper syntax highlighting
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "vue", "typescript", "javascript" })
      end
    end,
  },
}
