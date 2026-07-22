vim.loader.enable()
local augroup = vim.api.nvim_create_augroup("init.lua", {})

vim.pack.add({
    -- renovate: digest=15070f77066fce582f5fae09ce4faa080c33aefd
    { src = "https://github.com/oahlen/iceberg.nvim", name = "iceberg.nvim", version = "main" },
    -- renovate: digest=32fb8aa2edf3f172c307957dc7083e6c7f6caa7e
    { src = "https://github.com/Julian/lean.nvim", name = "lean.nvim", version = "main" },
    -- renovate: digest=1345d191bb3da9c7b0e977f4387c5761f9bff68d
    { src = "https://github.com/echasnovski/mini.nvim", name = "mini.nvim", version = "v0.18.0" },
    -- renovate: digest=5bfcc89fd155b4ffc02d18ab3b7d19c2d4e246a7
    { src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig", version = "v2.5.0" },
    -- renovate: digest=74b06c6c75e4eeb3108ec01852001636d85a932b
    { src = "https://github.com/nvim-lua/plenary.nvim", name = "plenary.nvim", version = "master" },
    -- renovate: digest=42fc28ba918343ebfd5565147a42a26580579482
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter", version = "master" },
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

now(function()
    require("mini.icons").setup()
end)

now(function()
    require("mini.basics").setup({
        options = {
            extra_ui = true,
        },
        mappings = {
            option_toggle_prefix = "m",
        },
    })
    vim.o.listchars = "tab:»-,trail:-,extends:»,eol:↲,precedes:«,nbsp:%"
    vim.o.signcolumn = "no"
    vim.g.maplocalleader = ","
end)

now(function()
    require("plugin/mini_misc")
end)

now(function()
    require("mini.starter").setup()
end)

now(function()
    if not vim.g.vscode then
        require("plugin/mini_statusline")
    end
end)

now(function()
    if not vim.g.vscode then
        require("plugin/mini_notify")
    end
end)

later(function()
    if not vim.g.vscode then
        require("plugin/mini_hipatterns")
    end
end)

later(function()
    if not vim.g.vscode then
        require("mini.cursorword").setup()
    end
end)

later(function()
    require("mini.indentscope").setup()
end)

later(function()
    require("mini.pairs").setup()
end)

later(function()
    require("mini.surround").setup()
end)

later(function()
    require("plugin/mini_ai")
end)

later(function()
    if not vim.g.vscode then
        require("plugin.mini_clue")
    end
end)

now(function()
    require("lsp")
end)

later(function()
    -- require("plugin/nvim-treesitter")
end)

later(function()
    if not vim.g.vscode then
        require("plugin.mini_completion")
    end
end)

now(function()
    if not vim.g.vscode then
        require("plugin/iceberg")
        vim.cmd.colorscheme("iceberg")
    end
end)

now(function()
    if not vim.g.vscode then
        require("plugin.mini_files")
    end
end)

later(function()
    if not vim.g.vscode then
        require("plugin.mini_pick")
    end
end)

later(function()
    require("mini.diff").setup()
end)

later(function()
    require("mini.jump").setup({
        delay = { idle_stop = 10 },
    })
end)

later(function()
    require("mini.jump2d").setup()
end)

if not vim.g.vscode then
    now(function()
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
end

later(function()
    vim.cmd.helptags("ALL")
end)
