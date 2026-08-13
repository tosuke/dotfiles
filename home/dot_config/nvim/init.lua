vim.loader.enable()
local augroup = vim.api.nvim_create_augroup("init.lua", {})

vim.pack.add({
    -- renovate: digest=7f23658b127b9a74aae5b388fefcd997be30cbfc
    { src = "https://github.com/delphinus/budoux.lua", name = "budoux.lua", version = "v1.0.2" },
    -- renovate: digest=15070f77066fce582f5fae09ce4faa080c33aefd
    { src = "https://github.com/oahlen/iceberg.nvim", name = "iceberg.nvim", version = "main" },
    -- renovate: digest=3d8027a96ada0fe43bdd01403e1bd4a09d175448
    { src = "https://github.com/Julian/lean.nvim", name = "lean.nvim", version = "main" },
    -- renovate: digest=1345d191bb3da9c7b0e977f4387c5761f9bff68d
    { src = "https://github.com/echasnovski/mini.nvim", name = "mini.nvim", version = "v0.18.0" },
    -- renovate: digest=1e55f744ae1d89d31f92e8af621f4428147db379
    { src = "https://github.com/delphinus/md-render.nvim", name = "md-render.nvim", version = "v3.4.1" },
    -- renovate: digest=b89138d9af0a96e6048e202a15765fc6b6416bd4
    { src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig", version = "v2.11.0" },
    -- renovate: digest=74b06c6c75e4eeb3108ec01852001636d85a932b
    { src = "https://github.com/nvim-lua/plenary.nvim", name = "plenary.nvim", version = "master" },
    -- renovate: digest=7b6cc8949f9999c5ed91436cbe24aa5f99c42025
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter", version = "main" },
})

vim.opt.title = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoread = true

-- Diagnostics
vim.diagnostic.config({
    virtual_lines = false,
    signs = false,
    virtual_text = {
        format = function(diagnostic)
            local severity_map = {
                [vim.diagnostic.severity.ERROR] = "E",
                [vim.diagnostic.severity.WARN] = "W",
                [vim.diagnostic.severity.INFO] = "I",
                [vim.diagnostic.severity.HINT] = "H",
            }
            return severity_map[diagnostic.severity] or ""
        end,
    },
})
vim.keymap.set("n", "ml", function()
    local config = vim.diagnostic.config()
    if config then
        config.virtual_lines = not config.virtual_lines
    end
    vim.diagnostic.config(config)
end, { desc = "Toggle diagnostic virtual lines" })

-- gf で URL を開く
vim.keymap.set("n", "gf", function()
    local cfile = vim.fn.expand("<cfile>")
    if cfile:match("^https?://") then
        vim.ui.open(cfile)
    else
        vim.cmd("normal! gF")
    end
end)

vim.filetype.add({
    extension = {
        -- SATySFi
        saty = "satysfi",
        satyh = "satysfi",
        satyg = "satysfi",
        -- Earthfile
        earth = "Earthfile",
        -- Typst
        typ = "typst",
    },
    filename = {
        ["Earthfile"] = "Earthfile",
        [".envrc"] = "sh",
        [".yamllint"] = "yaml",
    },
})

local packutil = require("packutil")
local now, later = packutil.now, packutil.later
local now_require, later_require = packutil.now_require, packutil.later_require
local now_setup, later_setup = packutil.now_setup, packutil.later_setup

now_setup("mini.icons")
now_setup("mini.basics", {
    options = {
        extra_ui = true,
    },
    mappings = {
        option_toggle_prefix = "m",
    },
})

now(function()
    vim.o.listchars = "tab:»-,trail:-,extends:»,eol:↲,precedes:«,nbsp:%"
    vim.o.signcolumn = "no"
    vim.g.maplocalleader = ","

    -- fold
    vim.opt.foldmethod = "indent"
    vim.opt.foldlevel = 99
    vim.keymap.set("n", "<Tab>", "za")

    -- md-render.nvim
    vim.keymap.set("n", "<localleader>mp", "<Plug>(md-render-preview)", { desc = "Markdown preview (toggle)" })
    vim.keymap.set(
        "n",
        "<localleader>mt",
        "<Plug>(md-render-preview-tab)",
        { desc = "Markdown preview in tab (toggle)" }
    )
    vim.keymap.set("n", "<leader>md", "<Plug>(md-render-demo)", { desc = "Markdown render demo" })
end)

now_require("plugin/mini_misc")

now(function()
    if vim.g.vscode then
        return
    end

    require("mini.starter").setup()
    require("lsp")

    require("plugin/mini_statusline")
    require("plugin/mini_notify")
    require("plugin.mini_files")

    require("plugin/iceberg")
    vim.cmd.colorscheme("iceberg")

    -- Load lean syntax & filetype
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
        group = augroup,
        pattern = "*.lean",
        once = true,
        callback = function()
            require("plugin.lean_nvim")
        end,
    })
end)

now_require("plugin.nvim-treesitter")

later_setup("mini.indentscope")
later_setup("mini.pairs")
later_setup("mini.surround")
later_require("plugin/mini_ai")

later_setup("mini.diff")
later_setup("mini.jump", {
    delay = { idle_stop = 10 },
})
later_setup("mini.jump2d")
later(function()
    vim.cmd.helptags("ALL")
end)

if not vim.g.vscode then
    later_require("plugin/mini_hipatterns")
    later_setup("mini.cursorword")
    later_require("plugin.mini_clue")
    later_require("plugin.mini_completion")
    later_require("plugin.mini_pick")
end
