vim.loader.enable()
local augroup = vim.api.nvim_create_augroup("init.lua", {})

vim.opt.title = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

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
    require("mini.jump").setup({
        delay = { idle_stop = 10 },
    })
end)

later(function()
    require("mini.jump2d").setup()
end)

later(function()
    if not vim.g.vscode then
        require("plugin.copilot")
    end
end)

if not vim.g.vscode then
    now(function()
        -- Load lean syntax & filetype
        vim.cmd.packadd("lean.nvim")
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
