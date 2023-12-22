local group = vim.api.nvim_create_augroup('init.lua', {})

-- 文字コード
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- 空白文字
vim.wo.list = true
vim.wo.listchars = 'tab:»-,trail:-,extends:»,eol:↲,precedes:«,nbsp:%'

-- 補完
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- 検索
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- タイトル
vim.opt.title = true

-- OS との間でクリップボード同期
vim.opt.clipboard = 'unnamedplus'

-- インデント
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true

vim.api.nvim_create_autocmd('Filetype', {
    group = group,
    pattern = { 'ocaml' },
    callback = function()
        vim.opt.softtabstop = 2
        vim.opt.shiftwidth = 2
    end
})

-- 分割
vim.opt.splitbelow = true
vim.opt.splitright = true

-- カラム
vim.o.signcolumn = 'yes'
vim.o.number = true
vim.o.cursorline = true

-- 括弧対応
-- FIXME: autopair があるからあまり旨味がないような気がするのでとりあえず落としておく
-- vim.o.showmatch = true
-- vim.o.matchtime = 1

-- キーバインド
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- US 配列だとつらいので ; と : を入れ替える
vim.keymap.set('n', ';', ':', { noremap = true })
vim.keymap.set('n', ':', ';', { noremap = true })
-- Esc 連打でハイライト消す
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':nohl<CR>', { noremap = true, silent = true })

-- ファイルタイプ
vim.filetype.add {
    extension = {
        -- SATySFi
        saty = 'satysfi',
        satyh = 'satysfi',
        satyg = 'satysfi',
        -- Earthfile
        earth = 'Earthfile',
    },
    filename = {
        ['Earthfile'] = 'Earthfile',
    }
}

-- プラグイン
-- シングルファイルにすると読み込み完了後に走るべき設定が見にくくなるので別にする
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins', {
    defaults = {
        lazy = true,
        version = false,
    },
    checker = { enabled = true },
    change_detection = {
        enabled = true,
        notify = false,
    },
    performance = {
        cache = { enabled = true },
        rtp = {
            disabled_plugins = {
                'gzip', 'tarPlugin', 'tohtml', 'totor', 'zipPlugin',
            }
        }
    },
})

-- 見た目
if not vim.g.vscode then
    vim.o.termguicolors = true
    vim.o.winblend = 20
    vim.o.pumblend = 20
    vim.cmd.colorscheme 'iceberg'
end
