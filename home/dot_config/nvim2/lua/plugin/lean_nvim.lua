vim.cmd.packadd("plenary.nvim")
vim.cmd.packadd("nvim-lspconfig")

require("lean").setup({
    mappings = true,
    abbreviations = {
        enable = true,
        extra = {},
        leader = [[\]],
    },
})
