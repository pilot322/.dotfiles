local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'luasnip' },
    },
    snippet = {
        expand = function(args)
            require 'luasnip'.lsp_expand(args.body)
        end,
    },
    formatting = {
        format = require('tailwindcss-colorizer-cmp').formatter
    },
    mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
})
