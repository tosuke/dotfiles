-- 文字コード
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- 空白文字
vim.wo.list = true
vim.wo.listchars = 'tab:»-,trail:-,extends:»,eol:↲,precedes:«,nbsp:%'

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
        saty = 'satysfi',
        satyh = 'satysfi',
        satyg = 'satysfi',
    },
}

-- プラグイン
-- シングルファイルにすると読み込み完了後に走るべき設定が見にくくなるので別にする
require 'plugin'

-- 見た目
if not vim.g.vscode then
    vim.o.termguicolors = true
    vim.o.winblend = 20
    vim.o.pumblend = 20
    vim.cmd.colorscheme 'iceberg'
end
