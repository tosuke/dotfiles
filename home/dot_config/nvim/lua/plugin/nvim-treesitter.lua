local treesitter = require("nvim-treesitter")
local augroup = vim.api.nvim_create_augroup("plugin/nvim-treesitter.lua", {})

treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})

local ts_filetypes = {
    "bash",
    "c",
    "cpp",
    "css",
    "diff",
    "fish",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "gotmpl",
    "html",
    "javascript",
    "json",
    "json5",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "rust",
    "sql",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
}

treesitter.install(ts_filetypes)

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = ts_filetypes,
    callback = function()
        vim.treesitter.start()
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
