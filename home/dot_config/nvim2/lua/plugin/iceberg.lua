local augroup = vim.api.nvim_create_augroup("plugin/iceberg.lua", {})

vim.cmd.packadd("iceberg.nvim")

vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup,
    pattern = "iceberg",
    callback = function()
        vim.api.nvim_set_hl(0, "Normal", { ctermbg = "None", bg = "None" })
        vim.api.nvim_set_hl(0, "NonText", { ctermbg = "None", bg = "None" })
    end,
})
