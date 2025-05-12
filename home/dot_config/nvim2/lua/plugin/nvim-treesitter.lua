vim.cmd.packadd("nvim-treesitter")
require("nvim-treesitter.configs").setup({
    auto_install = true,
    highlight = {
        enable = not vim.g.vscode,
    },
    indent = {
        enable = true,
    },
})
