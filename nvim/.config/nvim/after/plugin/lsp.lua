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


lspconf.pylsp.setup {
    settings = {
        pylsp = {
            configurationSources = { "flake8" },
            plugins = {
                flake8 = { enabled = true },
                pycodestyle = { enabled = false },
            }
        }
    }
}

vim.opt.shiftwidth = 4   -- Indent size
vim.opt.tabstop = 4      -- Number of spaces for a tab
vim.opt.expandtab = true -- Converts tabs to spaces

lspconf.intelephense.setup {
    settings = {
        intelephense = {
            stubs = {
                "apache", "bcmath", "blade", "bz2", "calendar", "com_dotnet", "Core",
                "ctype", "curl", "date", "dba", "dom", "enchant", "exif",
                "FFI", "fileinfo", "filter", "fpm", "ftp", "gd", "gettext",
                "gmp", "hash", "iconv", "imap", "intl", "json", "ldap",
                "libxml", "mbstring", "meta", "mysqli", "oci8", "odbc",
                "openssl", "pcntl", "pcre", "PDO", "pdo_ibm", "pdo_mysql",
                "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix", "pspell",
                "readline", "Reflection", "session", "shmop", "SimpleXML",
                "snmp", "soap", "sockets", "sodium", "SPL", "sqlite3",
                "standard", "superglobals", "sysvmsg", "sysvsem", "sysvshm",
                "tidy", "tokenizer", "xml", "xmlreader", "xmlrpc", "xmlwriter",
                "xsl", "Zend OPcache", "zip", "zlib", "laravel", "eloquent", "laravel-eloquent", "laravel-collections"
            },
            files = {
                -- Point to your IDE helper files
                maxSize = 10000000,
                associations = {
                    "*.php", "*.phtml", "*.inc", "*.module", "*.install", "*.theme"
                },
                include = {
                    vim.fn.getcwd() .. "/_ide_helper.php",
                    vim.fn.getcwd() .. "/_ide_helper_models.php",
                    vim.fn.getcwd() .. "/.phpstorm.meta.php",
                }
            }
        }

    },

}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "sh",
    command = "setlocal omnifunc=sh_omni",
})

lspconf.jsonls.setup({})
