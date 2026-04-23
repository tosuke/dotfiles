local augroup = vim.api.nvim_create_augroup("plugin/mini_statusline.lua", {})

require("mini.statusline").setup()
vim.opt.laststatus = 3
vim.opt.cmdheight = 1

vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup,
    pattern = "iceberg",
    callback = function()
        require("plugin/iceberg")
        local palette = require("iceberg/palette-dark")

        local hl = vim.api.nvim_set_hl
        hl(0, "MiniStatuslineModeNormal", { fg = "#818596", bg = "#17171b" })
        hl(0, "MiniStatuslineModeInsert", { fg = "#84a0c6", bg = "#161821" })
        hl(0, "MiniStatuslineModeVisual", { fg = "#b4be82", bg = "#161821" })
        hl(0, "MiniStatuslineModeReplace", { fg = "#e2a478", bg = "#161821" })
        hl(0, "MiniStatuslineModeCommand", { fg = "#a093c7", bg = "#161821" })
        hl(0, "MiniStatuslineModeOther", { fg = "#89b8c2", bg = "#161821" })
        hl(0, "MiniStatuslineFilename", { fg = "#0f1117", bg = palette.normal_fg })
        hl(0, "MiniStatuslineFileinfo", { fg = "#2e313f", bg = "#6b7089" })
        hl(0, "MiniStatuslineDevinfo", { fg = "#2e313f", bg = "#6b7089" })
    end,
})
