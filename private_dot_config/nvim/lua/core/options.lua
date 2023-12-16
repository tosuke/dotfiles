vim.o.title = true
vim.o.backup = false
vim.o.undofile = true
vim.o.encoding = 'utf-8'

-- visual
--vim.o.ambiwidth = 'double'
-- tab
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true

vim.o.visualbell = true
vim.o.number = true
vim.o.cursorline = true
vim.o.syntax = "on"

vim.o.showmatch = true
vim.o.matchtime = 1

vim.wo.list = true
vim.wo.listchars = 'tab:»-,trail:-,extends:»,eol:↲,precedes:«,nbsp:%'

vim.o.termguicolors = true
vim.o.winblend = 20
vim.o.pumblend = 20
vim.cmd.colorscheme 'iceberg'

-- search
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
-- Esc 連打でハイライト消す
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':nohl<CR>', { noremap = true, silent = true })
vim.o.clipboard = 'unnamedplus' -- OS と Neovim の間でクリップボードを同期する


