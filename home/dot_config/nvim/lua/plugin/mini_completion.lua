require("mini.fuzzy").setup()
require("mini.completion").setup({
    lsp_completion = {
        process_items = MiniFuzzy.process_lsp_items,
    },
})
-- require("mini.snippets").setup()
MiniIcons.tweak_lsp_kind()

vim.opt.complete = { ".", "w", "k", "b", "u", "t" }
vim.opt.completeopt:append("fuzzy")
-- vim.opt.dictionary:append("/usr/share/dict/words")
