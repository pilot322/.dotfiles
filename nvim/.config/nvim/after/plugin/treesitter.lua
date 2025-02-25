require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "java", "javascript", "typescript", 'php', 'html'},
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

vim.filetype.add({
  extension = {
    blade = "html"
  },
  pattern = {
    [".*%.blade%.php"] = "html"
  }
})
