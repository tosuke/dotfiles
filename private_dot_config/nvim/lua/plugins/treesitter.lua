function setup_treesitter()
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
end

function setup_rainbow_delimiters()
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

return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        {
            'HiPhish/rainbow-delimiters.nvim',
            config = setup_rainbow_delimiters,
        }
    },
    event = { 'BufReadPost', 'BufNewFile' },
    build = ':TSUpdate',
    cmd = { 'TSUpdateSync' },
    cond = function()
        return not vim.g.vscode
    end,
    config = function()
        setup_treesitter()
    end,
}
