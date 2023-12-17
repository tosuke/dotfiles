return {
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
