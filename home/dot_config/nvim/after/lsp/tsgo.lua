local supported_trigger_characters = {
    ["."] = true,
    ["@"] = true,
    ['"'] = true,
    ["'"] = true,
    ["`"] = true,
    ["#"] = true,
    ["<"] = true,
    ["/"] = true,
    [" "] = true,
}

---@type vim.lsp.Config
return {
    cmd = { "tsc", "--lsp", "--stdio" },
    init_options = {
        userPreferences = {
            preferGoToSourceDefinition = true,
        },
    },
    on_init = function(client)
        require("lsp.utils").disable_format(client)

        local provider = client.server_capabilities.completionProvider
        if provider then
            provider.triggerCharacters = vim.tbl_filter(function(char)
                return supported_trigger_characters[char]
            end, provider.triggerCharacters or {})
        end
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
