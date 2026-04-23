---@type vim.lsp.Config
return {
    settings = {
        yaml = {
            schemaStore = {
                enable = false, -- Disable default schema store
                url = "",
            },
            schemas = require("lsp.utils").schemas(),
        },
    },
}
