---@type vim.lsp.Config
return {
    settings = {
        vtsls = {
            autoUseWorkspaceTsdk = true,
        },
        typescript = {
            preferGoToSourceDefinition = true,
        },
        javascript = {
            preferGoToSourceDefinition = true,
        },
    },
    on_init = function(client)
        require("lsp.utils").disable_format(client)
    end,
    root_dir = function(bufnr, on_dir)
        local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml" }
        local negative_root_markers = { "deno.json", "deno.jsonc" }

        local root = vim.fs.root(bufnr, { root_markers })
        local negative_root = vim.fs.root(bufnr, { negative_root_markers })

        if negative_root or not root then
            return
        end

        on_dir(root)
    end,
}
