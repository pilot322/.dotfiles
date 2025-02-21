local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'render-markdown' },
    },
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    formatting = {
        format = require('tailwindcss-colorizer-cmp').formatter
    },
    mapping = cmp.mapping.preset.insert({}),
})
