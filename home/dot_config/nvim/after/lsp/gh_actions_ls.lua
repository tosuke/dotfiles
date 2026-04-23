---@type vim.lsp.Config
return {
    init_options = {},
    root_markers = nil,
    root_dir = function(bufnr, on_dir)
        local parent = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
        if
            vim.endswith(parent, "/.github/workflows")
            or vim.endswith(parent, "/.forgejo/workflows")
            or vim.endswith(parent, "/.gitea/workflows")
        then
            on_dir(parent)
        end
    end,
}
