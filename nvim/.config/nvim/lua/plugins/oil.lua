return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local selection = require("config.oil_selection")
      selection.setup()
      require("oil").setup({
        default_file_explorer = true,
        columns = {
          "icon",
          -- "permissions",
          -- "size",
          -- "mtime",
        },
        view_options = {
          show_hidden = false,
        },
        -- Enable LSP file operations (rename imports when moving files)
        lsp_file_methods = {
          enabled = true,
          timeout_ms = 2000, -- longer timeout for large projects
          autosave_changes = true
        },
        -- Keymaps in oil buffer
        keymaps = {
          ["<Tab>"] = { selection.toggle, mode = { "n", "x" }, desc = "Toggle file marks" },
          ["<S-Tab>"] = { selection.clear, mode = { "n", "x" }, desc = "Clear file marks / pending move" },
          ["<leader>ox"] = { selection.cut, mode = "n", desc = "Stage marked files to move" },
          ["<leader>op"] = { selection.paste, mode = "n", desc = "Paste marked files" },
          ["<leader>oc"] = { selection.clear, mode = "n", desc = "Clear file marks / pending move" },
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-v>"] = "actions.select_vsplit",
          ["<C-x>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
      })

      -- Set keymap to open oil
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },
}
