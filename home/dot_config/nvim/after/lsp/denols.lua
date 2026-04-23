---@type vim.lsp.Config
return {
    root_dir = function(bufnr, on_dir)
        local root_markers = { "deno.json", "deno.jsonc" }
        local negative_root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml" }

        local root = vim.fs.root(bufnr, { root_markers })
        local negative_root = vim.fs.root(bufnr, { negative_root_markers })

        if negative_root or not root then
            return
        end

        on_dir(root)
    end,
}
