---@type vim.lsp.Config
return {
    on_init = function(client)
        require("lsp.utils").disable_format(client)
    end,
}
