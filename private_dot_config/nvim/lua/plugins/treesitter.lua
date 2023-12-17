local treesitter = {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {},
    event = { 'BufReadPost', 'BufNewFile' },
    build = ':TSUpdate',
    cmd = { 'TSUpdateSync' },
    cond = function()
        return not vim.g.vscode
    end,
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
}

table.insert(treesitter.dependencies, {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
        require('treesitter-context').setup {
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
        }
    end
})

table.insert(treesitter.dependencies, {
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
})

return {
    treesitter,
}
