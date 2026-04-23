local augroup = vim.api.nvim_create_augroup("after/lsp/copilot.lua", {})
local disabled_filetypes = {
    help = true,
    hgcommit = true,
    svn = true,
    cvs = true,
}

local function apply_copilot_highlight()
    vim.api.nvim_set_hl(
        0,
        "ComplHint",
        vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = "Comment" }), { underline = true })
    )
end

apply_copilot_highlight()
vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup,
    pattern = "*",
    callback = apply_copilot_highlight,
})

local base_config
for _, path in ipairs(vim.api.nvim_get_runtime_file("lsp/copilot.lua", true)) do
    if not path:match("/after/lsp/copilot%.lua$") then
        base_config = dofile(path)
        break
    end
end

---@type vim.lsp.Config
return {
    root_dir = function(bufnr, on_dir)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("env") then
            return
        end

        if disabled_filetypes[vim.bo[bufnr].filetype] then
            return
        end

        local root = vim.fs.root(bufnr, { ".git" })
        if root then
            on_dir(root)
        end
    end,
    on_attach = function(client, bufnr)
        if base_config and base_config.on_attach then
            base_config.on_attach(client, bufnr)
        end

        local filter = { client_id = client.id }
        vim.lsp.inline_completion.enable(true, filter)

        vim.keymap.set("i", "<C-e>", function()
            if not vim.lsp.inline_completion.get({ bufnr = bufnr }) then
                return vim.keycode("<C-e>")
            end
        end, { buffer = bufnr, desc = "Accept Inline Completion", expr = true })
        vim.keymap.set("i", "<C-f>", function()
            vim.lsp.inline_completion.select({ bufnr = bufnr, count = 1 })
        end, { buffer = bufnr, desc = "Next Inline Completion" })
        vim.keymap.set("i", "<C-b>", function()
            vim.lsp.inline_completion.select({ bufnr = bufnr, count = -1 })
        end, { buffer = bufnr, desc = "Previous Inline Completion" })
    end,
}
