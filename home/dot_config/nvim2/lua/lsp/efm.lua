local M = {}
local async = require("plenary.async")

local efm_config = nil

function M.setup()
    async.void(function()
        local async_system = async.wrap(vim.system, 3)

        local efm_result = async_system({ "efm-langserver", "-d" }, { text = true })
        if efm_result.code ~= 0 then
            vim.notify("Failed to dump efm-langserver config", vim.log.levels.ERROR)
            return
        end

        local yq_result = async_system({ "yq", "-ojson" }, { text = true, stdin = efm_result.stdout })
        if yq_result.code ~= 0 then
            vim.notify("Failed to parse efm-langserver config", vim.log.levels.ERROR)
            return
        end

        efm_config = vim.json.decode(yq_result.stdout)
        local filetypes = {}
        for ft, _ in pairs(efm_config.languages) do
            table.insert(filetypes, ft)
        end
        vim.lsp.config("efm", {
            cmd = { "efm-langserver" },
            filetypes = filetypes,
        })
        vim.lsp.enable("efm")
    end)()
end

return M
