local not_vscode = function()
    return not vim.g.vscode
end

local plugins = {
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
        opts = {
            options = {
                icons_enabled = true,
                theme = 'auto',
                always_devide_middle = true,
            },
        },
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
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
        end,
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter-context',
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
            }
        },
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
            { '<leader><leader>',   '<cmd>Telescope find_files<cr>',    desc = 'find files' },
            { '<leader>fg',         '<cmd>Telescope live_grep<cr>',     desc = '[F]ind with [G]rep' },
            { '<leader>fb',         '<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>',
                                                                        desc = '[F]ile [B]rowser' },
            { '<leader>fc',         '<cmd>Telescope git_status<cr>',    desc = '[F]ind [C]hanges' },
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'nvim-telescope/telescope-file-browser.nvim',
        },
        config = function()
            local telescope = require 'telescope'
            local actions = require 'telescope.actions'
            telescope.setup {
                defaults = {
                    winblend = 20,
                    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                    layout_strategy = 'vertical',
                    mappings = {
                        i = {
                            ['<C-h>'] = actions.which_key,
                        },
                    },
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

            local builtin = require 'telescope.builtin'
            vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'find [B]uffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'find [H]elps' })
        end,
    }
}
return plugins
