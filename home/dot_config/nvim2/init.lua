vim.loader.enable()
local augroup = vim.api.nvim_create_augroup("init.lua", {})

vim.opt.title = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- キーバインド
-- US 配列だとつらいので ; と : を入れ替える
vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("n", ":", ";", { noremap = true })
vim.api.nvim_set_keymap("n", "<Esc><Esc>", ":nohl<CR>", { noremap = true, silent = true, desc = "no highlight" })
-- textobj を囲む空白を選択しない
for _, quote in ipairs({ '"', "'", "`" }) do
    vim.keymap.set({ "x", "o" }, "a" .. quote, "2i" .. quote)
end

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

-- mini.deps (use only utils)
require("mini.deps").setup()

local now, later = MiniDeps.now, MiniDeps.later

now(function()
    require("mini.icons").setup()
end)

now(function()
    require("mini.basics").setup({
        options = {
            basic = true,
            extra_ui = true,
        },
        mappings = {
            basic = true,
            option_toggle_prefix = "m",
        },
        autocommands = {
            basic = true,
        },
    })
    vim.o.listchars = "tab:»-,trail:-,extends:»,eol:↲,precedes:«,nbsp:%"
    vim.o.signcolumn = "no"
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

later(function()
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
    require("plugin/nvim-treesitter")
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
    if not vim.g.vscode then
        require("plugin.copilot")
    end
end)

later(function()
    vim.cmd.helptags("ALL")
end)
