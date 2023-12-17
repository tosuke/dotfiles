return {
    'nvim-telescope/telescope.nvim',
    cmd = { 'Telescope', },
    event = { 'BufReadPre', 'BufNewFile', },
    keys = {
        { '<leader><leader>',   '<cmd>Telescope find_files<cr>',    desc = 'find files' },
        { '<leader>g',          '<cmd>Telescope live_grep<cr>',     desc = '[G]rep files' },
        { '<leader>fb',         '<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>',
                                                                    desc = '[F]ile [B]rowser' },
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
        local builtin = require 'telescope.builtin'
        telescope.setup({
            defaults = {
                winblend = 20,
                borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                layout_strategy = 'vertical',
                mappings = {
                    i = {
                        ['<C-h>'] = actions.which_key,
                        ['<C-u>'] = false,
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
        })
        telescope.load_extension 'fzf'
        telescope.load_extension 'file_browser'

        vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'find [B]uffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'find [H]elps' })
    end,
}
