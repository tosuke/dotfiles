local augroup = vim.api.nvim_create_augroup("plugin/nvim-treesitter.lua", {})

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

require("nvim-treesitter").install(ts_filetypes)

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = ts_filetypes,
    callback = function()
        vim.treesitter.start()
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldlevel = 2
        vim.wo[0][0].foldminlines = 2
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
