-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end,
})

require('lspconfig').clangd.setup({
})

require('lspconfig').jdtls.setup {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/jdtls' },
    root_dir = vim.fn.getcwd(), -- Use the current working directory as the project root
}

require('lspconfig').html.setup {
    filetypes = { "html", "htm", "blade" },
}

require('lspconfig').cssls.setup {
    filetypes = { "css", "scss", "less" },
}
lspconf = require 'lspconfig'
require('lspconfig').tailwindcss.setup({
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

require('lspconfig').lua_ls.setup {}

require 'lspconfig'.marksman.setup {}

require('lspconfig').ts_ls.setup {}

lspconf.yamlls.setup {}


lspconf.pylsp.setup {}

vim.opt.shiftwidth = 4   -- Indent size
vim.opt.tabstop = 4      -- Number of spaces for a tab
vim.opt.expandtab = true -- Converts tabs to spaces

lspconf.intelephense.setup {
    settings = {
        intelephense = {
            stubs = { "blade" } -- This is illustrative; check the intelephense docs for any Blade-specific settings.
        }
    },
}
