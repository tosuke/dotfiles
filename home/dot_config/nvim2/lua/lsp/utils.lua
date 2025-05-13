local M = {}

---@param client vim.lsp.Client
function M.disable_format(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

return M
