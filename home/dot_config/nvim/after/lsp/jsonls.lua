---@type vim.lsp.Config
return {
    settings = {
        json = {
            schemas = require("lsp.utils").schemas(),
            validate = { enable = true },
        },
    },
    on_init = function(client)
        require("lsp.utils").disable_format(client)
    end,
}
