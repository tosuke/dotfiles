local group = vim.api.nvim_create_augroup("init.lua", {})

-- 文字コード
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- 空白文字
vim.wo.list = true
vim.wo.listchars = "tab:»-,trail:-,extends:»,eol:↲,precedes:«,nbsp:%"

-- 補完
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10

-- 検索
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- タイトル
vim.opt.title = true

-- 無名レジスタをクリップボードレジスタにする
-- システム側のコピーは無名レジスタ"*"に入るので無条件で p できる
-- vim 側のヤンクをシステム側に送りたいなら"+"を指定する必要がある(e.g. "+yy)
-- unnamedplus は無名レジスタを"+"にするが、こうするとシステム側のクリップボードが Vim の操作によって汚れてしまう
vim.opt.clipboard = "unnamed"

-- インデント
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true

vim.api.nvim_create_autocmd("Filetype", {
    group = group,
    pattern = { "go" },
    callback = function()
        vim.opt.expandtab = false
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
    end,
})

-- インデント2スペース族
vim.api.nvim_create_autocmd("Filetype", {
    group = group,
    pattern = {
        "ocaml",
        "haskell",
        "terraform",
        "hcl",
        "json",
        "javascript",
        "typescript",
        "typescriptreact",
        "proto",
    },
    callback = function()
        vim.opt.expandtab = true
        vim.opt.softtabstop = 2
        vim.opt.shiftwidth = 2
    end,
})

-- 分割
vim.opt.splitbelow = true
vim.opt.splitright = true

-- カラム
vim.o.signcolumn = "yes"
vim.o.number = true
vim.o.cursorline = true

-- 括弧対応
-- FIXME: autopair があるからあまり旨味がないような気がするのでとりあえず落としておく
-- vim.o.showmatch = true
-- vim.o.matchtime = 1

-- エラー表示
vim.diagnostic.config({ virtual_text = false })

vim.o.modeline = true

-- キーバインド
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- US 配列だとつらいので ; と : を入れ替える
vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("n", ":", ";", { noremap = true })
-- Esc 連打でハイライト消す
vim.api.nvim_set_keymap("n", "<Esc><Esc>", ":nohl<CR>", { noremap = true, silent = true })
-- textobj を囲む空白を選択しない
for _, quote in ipairs({ '"', "'", "`" }) do
    vim.keymap.set({ "x", "o" }, "a" .. quote, "2i" .. quote)
end

-- gf で URL を開く
vim.keymap.set("n", "gf", function()
    local cfile = vim.fn.expand("<cfile>")
    if cfile:match("^https?://") then
        vim.ui.open(cfile)
    else
        vim.cmd("normal! gF")
    end
end)

-- ファイルタイプ
vim.filetype.add({
    extension = {
        -- SATySFi
        saty = "satysfi",
        satyh = "satysfi",
        satyg = "satysfi",
        -- Earthfile
        earth = "Earthfile",
    },
    filename = {
        ["Earthfile"] = "Earthfile",
        [".envrc"] = "sh",
        [".yamllint"] = "yaml",
    },
})

-- プラグイン
-- シングルファイルにすると読み込み完了後に走るべき設定が見にくくなるので別にする
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    spec = {
        { import = "plugins" },
        { import = "tools" },
    },
    defaults = {
        lazy = true,
    },
    checker = { enabled = false },
    change_detection = {
        enabled = true,
        notify = false,
    },
    performance = {
        cache = { enabled = true },
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "totor",
                "zipPlugin",
            },
        },
    },
})

-- 見た目
if not vim.g.vscode then
    vim.o.termguicolors = true
    vim.o.winblend = 10
    vim.o.pumblend = 10
    vim.cmd.colorscheme("iceberg")
end
