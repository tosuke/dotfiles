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

local format_ls_rules = {
    "biome",
    "efm",
    "*",
}

function M.format_buf(bufnr)
    local mode = vim.api.nvim_get_mode()
    local method = "textDocument/formatting"
    if mode.mode == "v" or mode.mode == "V" then
        method = "textDocument/rangeFormatting"
    end

    for _, rule in ipairs(format_ls_rules) do
        ---@type string|nil
        local name = rule
        if rule == "*" then
            name = nil
        end
        local clients = vim.lsp.get_clients({
            bufnr = bufnr,
            method = method,
            name = name,
        })

        ---@type vim.lsp.Client|nil
        local client = nil
        if #clients == 1 then
            client = clients[1]
        elseif #clients > 1 then
            local items = {}
            for _, c in ipairs(clients) do
                table.insert(items, {
                    text = (c.id .. ": " .. c.name),
                    client = c,
                })
            end

            local choice = MiniPick.start({
                source = { items = items },
            })
            if choice then
                client = choice.client
            end
        end

        if client then
            vim.lsp.buf.format({
                bufnr = bufnr,
                id = client.id,
                timeout_ms = 5000,
            })
            break
        end
    end
end

return M
