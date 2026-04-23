---@type vim.lsp.Config
return {
    on_attach = function(client, bufnr)
        vim.keymap.set("n", "<localleader>tp", function()
            client:exec_cmd({
                title ="startPreview",
                command = "tinymist.startDefaultPreview",
                arguments = { vim.api.nvim_buf_get_name(bufnr) },
            })
        end, { buffer = bufnr, desc = "Open preview" })
    end,
}
