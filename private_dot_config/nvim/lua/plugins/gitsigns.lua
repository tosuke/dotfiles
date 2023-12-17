return {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    cond = function()
        return not vim.g.vscode
    end,
    opts = {},
}
