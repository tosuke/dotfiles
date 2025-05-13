vim.cmd.packadd("nvim-lspconfig")

require("lean").setup({
    mappings = true,
    abbreviations = {
        enable = true,
        extra = {},
        leader = [[\]],
    },
})
