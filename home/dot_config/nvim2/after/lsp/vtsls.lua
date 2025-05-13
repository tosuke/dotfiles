return {
    single_file_support = false,
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
    on_attach = function(client)
        -- Disable formatting
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
    root_dir = function(bufnr, callback)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local dir = vim.fs.dirname(vim.fs.normalize(fname))
        local root_dir = vim.fs.root(dir, { ".git", "package.json", "tsconfig.json", "jsconfig.json" })
        if not root_dir then
            return
        end
        local deno_dirs = vim.fs.find({ "deno.json", "deno.jsonc" }, { upward = true, stop = root_dir, path = dir })
        if #deno_dirs > 0 then
            return
        end
        callback(root_dir)
    end,
}
