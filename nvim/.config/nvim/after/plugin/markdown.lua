--require('render-markdown').setup({
--    render_modes = true,
--})
--
--vim.cmd [[syntax match UnderlineText "__[^_]\+__" | highlight UnderlineText gui=underline cterm=underline]]
--
--local cmp = require 'cmp'
--
--cmp.setup {
--    sources = cmp.config.sources(
--        {
--            {
--                name = 'render-markdown',
--            }
--        }
--    ),
--}
--
--
