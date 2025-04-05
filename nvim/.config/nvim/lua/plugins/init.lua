-- lua/plugins.lua (or lua/plugins/init.lua)

return {

    -- Core Dependencies (often implicitly required, but good to list)
    { "nvim-lua/plenary.nvim",       lazy = true },
    { "MunifTanjim/nui.nvim",        lazy = true },
    { "nvim-tree/nvim-web-devicons", lazy = true }, -- Load early if needed by statusline/bufferline

    -- Colorscheme
    {
        "rose-pine/neovim",
        name = "rose-pine", -- Use 'name' instead of 'as'
        lazy = false,       -- Load theme early
        priority = 1000,    -- Ensure it loads before other plugins
        config = function()
            -- vim.cmd('colorscheme rose-pine') -- Or rose-pine-moon, etc.
            -- Put your theme setting logic here or in a separate config file
            -- require('core.colorscheme') -- Example if you abstract it
        end,
    },

    -- Telescope and Extensions
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",     -- Or keep up-to-date with a specific version/branch
        cmd = "Telescope", -- Lazy load on command
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Optional: needed for previewers, sorters, etc.
            -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            -- { "nvim-telescope/telescope-ui-select.nvim" },
        },
        config = function()
            -- Basic setup call, move your detailed Telescope config here
            require("telescope").setup({
                -- Your Telescope options, e.g., extensions = { file_browser = {} }
            })
            -- Load extensions
            pcall(require("telescope").load_extension, "file_browser")
        end,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        -- Configuration is often done within telescope's setup (see above)
        -- No separate config needed here unless you have specific file_browser setup
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",                    -- Use 'build' key for run commands
        event = { "BufReadPre", "BufNewFile" }, -- Load early for highlighting

    },
    {
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle", -- Load when command is run
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPre", "BufNewFile" }, -- Load with treesitter
        dependencies = { "nvim-treesitter/nvim-treesitter" },

    },

    -- Git
    { "tpope/vim-fugitive", cmd = { "Git", "G" } }, -- Load on Git commands
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" }, -- Load on buffer events
    },

    -- Utility
    {
        "theprimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")
            vim.keymap.set("n", "<leader>a", mark.add_file)
            vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
            vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
            vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
            vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
            vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)
        end

    },                                            -- Add keys = { ... } for lazy loading on keypress
    { "mbbill/undotree",    cmd = "UndotreeToggle" },
    { "tpope/vim-surround", event = "VeryLazy" }, -- Load very late or on first use via keys
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter", -- Load when entering insert mode

    },

    -- LSP / Completion Setup (using lsp-zero preset)
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x', -- Use the recommended branch
        lazy = false,    -- Or use event = "VeryLazy" / cmd = "LspInfo" etc. if you prefer lazy loading LSP
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' }, -- Bridge between mason and lspconfig

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lua' }, -- If you use Lua completion

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' }, -- Snippet collection

            -- Add other sources for nvim-cmp if you use them
            { "adoolaard/nvim-cmp-laravel" },
            { "roobert/tailwindcss-colorizer-cmp.nvim" },
        },
        config = function()
            -- Your lsp-zero setup call
            local lsp_zero = require('lsp-zero')
            lsp_zero.on_attach(function(client, bufnr)
                -- your on_attach function content (keymaps etc.)
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)

            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = { 'eslint', 'tailwindcss', 'phpactor', 'intelephense', 'lua_ls' }, -- Add your LSPs
                handlers = {
                    lsp_zero.default_setup_servers,
                    -- Example custom handler for specific servers
                    -- lua_ls = function()
                    --   local lua_opts = lsp_zero.nvim_lua_ls()
                    --   require('lspconfig').lua_ls.setup(lua_opts)
                    -- end,
                }
            })

            -- nvim-cmp setup (lsp-zero might handle some of this, check its docs)
            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            cmp.setup({
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'cmp_laravel' },               -- Add laravel source
                    { name = 'tailwindcss-colorizer-cmp' }, -- Add tailwind source
                }),
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Confirm without selecting if no item chosen
                }),
                -- Add other cmp settings...
            })

            -- Setup tailwind colorizer AFTER cmp setup
            require("tailwindcss-colorizer-cmp").setup({
                color_square_width = 2,
            })

            -- Setup nvim-cmp-laravel AFTER cmp setup
            require("nvim-cmp-laravel").setup()
        end
    },

    -- Snippets Engine (if not handled entirely by lsp-zero)
    -- { 'L3MON4D3/LuaSnip', version = "v2.*", build = "make install_jsregexp", event = "InsertEnter" },
    -- { "rafamadriz/friendly-snippets", event = "VeryLazy" }, -- Loaded when luasnip needs it

    -- Formatting/Linting (null-ls is deprecated, consider none-ls.nvim)
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            -- Your null-ls setup
            -- NOTE: null-ls is deprecated. Consider migrating to none-ls.nvim
            -- or using LSP formatters/linters directly.
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- Add your null-ls sources (e.g., null_ls.builtins.formatting.prettier)
                },
            })
        end,
    },

    -- Markdown
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "markdown", -- Load only for markdown files
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        config = function()
            require('render-markdown').setup({})
            vim.g.mkdp_enable_html = 1 -- This seems related to a different markdown previewer (vim-markdown-preview)? Check if needed for render-markdown.
        end,
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*",      -- Use version = "*" for tag = "*"
        -- lazy = true, -- Can be lazy-loaded
        event = "VeryLazy", -- Or ft = "markdown"
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Laravel Specific
    {
        "adalessa/laravel.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "MunifTanjim/nui.nvim",
            "tpope/vim-dotenv",           -- Make sure this is also in your plugin list
            "kevinhwang91/promise-async", -- Make sure this is also in your plugin list
        },
        ft = { "php", "blade" },          -- Load for relevant filetypes
        -- config = function()
        --   require("laravel").setup({
        --     -- Your laravel.nvim config
        --   })
        --   -- Load telescope extension if needed
        --   pcall(require("telescope").load_extension, "laravel")
        -- end,
    },
    { "tpope/vim-dotenv",           event = "VeryLazy" }, -- Dependency for laravel.nvim
    { "kevinhwang91/promise-async", lazy = true },        -- Dependency for laravel.nvim

    -- AI / Avante
    { "stevearc/dressing.nvim",     event = "VeryLazy" },   -- UI enhancement, load late
    { "HakonHarnes/img-clip.nvim",  cmd = "ImgClipPaste" }, -- Load on command
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter", -- Or just cmd
        config = function()
            require("copilot").setup({
                -- your copilot config
            })
        end,
    },
    --  {
    --      "yetone/avante.nvim",
    --      event = "VeryLazy",
    --      version = false, -- Never set this value to "*"! Never!
    --      opts = {
    --          -- add any opts here
    --          -- for example
    --          provider = 'gemini',
    --          gemini = {},
    --          openai = {
    --              endpoint = "https://api.openai.com/v1",
    --              model = "gpt-4o",  -- your desired model (or use gpt-4o, etc.)
    --              timeout = 30000,   -- Timeout in milliseconds, increase this for reasoning models
    --              temperature = 0,
    --              max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
    --              --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
    --          },
    --      },
    --      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    --      build = "make",
    --      -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    --      dependencies = {
    --          "nvim-treesitter/nvim-treesitter",
    --          "stevearc/dressing.nvim",
    --          "nvim-lua/plenary.nvim",
    --          "MunifTanjim/nui.nvim",
    --          --- The below dependencies are optional,
    --          "echasnovski/mini.pick",         -- for file_selector provider mini.pick
    --          "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    --          "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
    --          "ibhagwan/fzf-lua",              -- for file_selector provider fzf
    --          "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
    --          "zbirenbaum/copilot.lua",        -- for providers='copilot'
    --          {
    --              -- support for image pasting
    --              "HakonHarnes/img-clip.nvim",
    --              event = "VeryLazy",
    --              opts = {
    --                  -- recommended settings
    --                  default = {
    --                      embed_image_as_base64 = false,
    --                      prompt_for_file_name = false,
    --                      drag_and_drop = {
    --                          insert_mode = true,
    --                      },
    --                      -- required for Windows users
    --                      use_absolute_path = true,
    --                  },
    --              },
    --          },
    --      },
    --  }
}
