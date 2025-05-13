local M = {}

---@param client vim.lsp.Client
function M.disable_format(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

local schema_path = "~/.local/share/schemastore.json"
local schema_store = nil

local function load_schema()
    if schema_store ~= nil then
        return schema_store
    end

    local file = assert(io.open(vim.fn.expand(schema_path), "r"))
    local content = assert(file:read("*a"))
    assert(file:close())

    schema_store = vim.json.decode(content)
    return schema_store
end

function M.schemas()
    return load_schema().schemas
end

return M
