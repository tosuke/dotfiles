---@type vim.lsp.Config
return {
    cmd = { "oxlint", "--lsp" },
    on_init = function(client)
        require("lsp.utils").disable_format(client)
    end,
}
