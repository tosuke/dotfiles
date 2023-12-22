local not_vscode = function()
    return not vim.g.vscode
end

local plugins = {
    -- self
    'folke/lazy.nvim',
    -- colorscheme
    {
        'cocopon/iceberg.vim',
        cond = not_vscode,
        config = function()
            local augrp = vim.api.nvim_create_augroup('iceberg', { clear = true })
            vim.api.nvim_create_autocmd('ColorScheme', {
                group = augrp,
                pattern = 'iceberg',
                callback = function()
                    local highlight = {
                        -- rainbow-delimiters
                        --   from cocopon/vscode-iceberg-theme/editorBracketHighlight.*
                        RainbowDelimiter1 = { fg = '#84a0c6' }, -- foreground1
                        RainbowDelimiter2 = { fg = '#89b8c2' }, -- foreground2
                        RainbowDelimiter3 = { fg = '#b4be82' }, -- foreground3
                        RainbowDelimiter4 = { fg = '#e2a478' }, -- foreground4
                        RainbowDelimiter5 = { fg = '#a093c7' }, -- foreground5
                    }
                    for group, conf in pairs(highlight) do
                        vim.api.nvim_set_hl(0, group, conf)
                    end
                end,
            })
        end,
    },
    -- appearance
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        cond = not_vscode,
        opts = {},
    },
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        config = function()
            local function diff_source()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed,
                    }
                end
            end
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'auto',
                    disabled_filetypes = { 'TelescopePrompt' },
                    always_devide_middle = true,
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = {
                        { 'b:gitsigns_head', icon = '' },
                        { 'diff', source = diff_source },
                        'diagnostics',
                    },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                }
            }
        end
    },
    {
        url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        event = { 'BufEnter' },
        config = function()
            require('lsp_lines').setup()
        end
    },
    -- syntax
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufReadPost', 'BufNewFile' },
        build = ':TSUpdate',
        cmd = { 'TSUpdateSync' },
        cond = not_vscode,
        config = function()
            local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
            parser_config.satysfi = {
                install_info = {
                    url = 'https://github.com/monaqa/tree-sitter-satysfi.git',
                    files = { 'src/parser.c', 'src/scanner.c' },
                },
                filetype = 'satysfi',
            }

            require('nvim-treesitter.configs').setup {
                -- なくて困ったら入れればよい
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = 'gnn',
                        node_incremental = 'grn',
                        scope_incremental = 'grc',
                        node_decremental = 'grm',
                    },
                },
            }
        end,
    },
    {
        'earthly/earthly.vim',
        ft = { 'Earthfile' }
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            enable = true,
            max_lines = 0, -- unlimited
            min_window_height = 20,
            line_numbers = true,
            multiline_threshold = 10,
            trim_scope = 'outer',
            mode = 'cursor',
            separator = nil,
            zindex = 20,
            on_attach = nil,
        },
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            local rd = require 'rainbow-delimiters'
            require('rainbow-delimiters.setup').setup {
                strategy = {
                    [''] = rd.strategy['global'],
                    vim = rd.strategy['local'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    lua = 'rainbow-blocks',
                },
                highlight = {
                    'RainbowDelimiter1',
                    'RainbowDelimiter2',
                    'RainbowDelimiter3',
                    'RainbowDelimiter4',
                    'RainbowDelimiter5',
                },
            }
        end
    },
    {
        'windwp/nvim-autopairs',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        event = 'InsertEnter',
        config = function()
            local npairs = require 'nvim-autopairs'
            npairs.setup {
                check_ts = true,
            }
        end
    },
    -- fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        cmd = { 'Telescope', },
        keys = {
            {
                '<leader><leader>',
                '<cmd>Telescope find_files hidden=true<cr>',
                desc = 'find files'
            },
            { '<leader>gg', '<cmd>Telescope live_grep<cr>',  desc = '[G]rep' },
            { '<leader>gs', '<cmd>Telescope git_status<cr>', desc = '[G]it [S]tatus' },
            { '<leader>b',  '<cmd>Telescope buffers<cr>',    desc = 'find [B]uffers' },
            { '<leader>q',  '<cmd>Telescope diagnostics<cr>' },
            { '<leader>gr', '<cmd>Telescope lsp_references<cr>' },
            {
                '<leader>gf',
                '<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>',
                desc = '[F]iles'
            },
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'nvim-telescope/telescope-file-browser.nvim',
            'lewis6991/gitsigns.nvim',
        },
        config = function()
            local telescope = require 'telescope'
            local actions = require 'telescope.actions'
            telescope.setup {
                defaults = {
                    winblend = 20,
                    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                    color_devicons = true,
                    file_ignore_patterns = { 'node_modules', '.git', '.cache', '.npm', 'go' },
                    layout_strategy = 'vertical',
                    mappings = {
                        i = {
                            ['<C-h>'] = actions.which_key,
                        },
                    },
                },

                vimgrep_arguments = {
                    'rg',
                    '--color=never',
                    '--no-heading',
                    '--smart-case',
                    '-uu',
                },

                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = 'smart_case',
                    },
                    file_browser = {
                        theme = 'ivy',
                    }
                },
            }
            telescope.load_extension 'fzf'
            telescope.load_extension 'file_browser'
        end,
    },
    -- completion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            -- snippet
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
            -- autopairs
            'windwp/nvim-autopairs',
        },
        event = { 'InsertEnter', 'CmdlineEnter' },
        config = function()
            local cmp = require 'cmp'

            cmp.setup {
                snippet = {
                    expand = function(args)
                        vim.fn['vsnip#anonymous'](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false
                    },
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                }, {
                    { name = 'buffer' },
                })
            }

            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })

            -- 補完後に括弧類を挿入する
            local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end
    },
    -- LSP
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            {
                'nvimtools/none-ls.nvim',
                dependencies = { 'nvim-lua/plenary.nvim' }
            },
            'hrsh7th/cmp-nvim-lsp',
        },
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local lspcfg = require 'lspconfig'
            local null_ls = require 'null-ls'
            local nsources = {}
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local function setup_lsp(setup, config)
                config.capabilities = capabilities
                setup(config)
            end

            -- Go
            setup_lsp(lspcfg.gopls.setup, {})

            -- Rust
            setup_lsp(lspcfg.rust_analyzer.setup, {})

            -- OCaml
            setup_lsp(lspcfg.ocamllsp.setup, {})
            table.insert(nsources, null_ls.builtins.formatting.ocamlformat)

            -- Lua
            setup_lsp(lspcfg.lua_ls.setup, {})

            -- json
            setup_lsp(lspcfg.jsonls.setup, {})

            null_ls.setup {
                sources = nsources
            }

            local opts = { noremap = true, silent = true }
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

            local group = vim.api.nvim_create_augroup('UserLspConfig', {})
            vim.api.nvim_create_autocmd('LspAttach', {
                group = group,
                callback = function(ev)
                    -- <C-x><C-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    local bopts = { noremap = true, silent = true, buffer = ev.buf }

                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bopts)
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bopts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bopts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bopts)
                    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bopts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bopts)
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bopts)
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, bopts)
                end
            })
        end
    },

}
return plugins
