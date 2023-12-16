return {
    {
        'cocopon/iceberg.vim',
        event = 'VimEnter',
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
}
