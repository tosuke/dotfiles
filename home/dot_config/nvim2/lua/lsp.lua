-- load lspconfig
vim.cmd.packadd("nvim-lspconfig")

local augroup = vim.api.nvim_create_augroup("lsp.lua", {})

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

        require("plugin.mini_pick")

        if client:supports_method("textDocument/hover", ev.buf) then
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "LSP Hover" })
        end
        if client:supports_method("textDocument/signatureHelp", ev.buf) then
            vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature Help" })
            vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature Help" })
        end

        if client:supports_method("textDocument/definition", ev.buf) then
            vim.keymap.set("n", "gd", function()
                require("mini.extra").pickers.lsp({ scope = "definition" })
            end, { buffer = ev.buf, desc = "Go to definition" })
        end
        if client:supports_method("textDocument/declaration", ev.buf) then
            vim.keymap.set("n", "gD", function()
                require("mini.extra").pickers.lsp({ scope = "declaration" })
            end, { buffer = ev.buf, desc = "Go to declaration" })
        end
        if client:supports_method("textDocument/typeDefinition", ev.buf) then
            vim.keymap.set("n", "grt", function()
                require("mini.extra").pickers.lsp({ scope = "type_definition" })
            end, { buffer = ev.buf, desc = "Go to type definition" })
        end
        if client:supports_method("textDocument/implementation", ev.buf) then
            vim.keymap.set("n", "gri", function()
                require("mini.extra").pickers.lsp({ scope = "implementation" })
            end, { buffer = ev.buf, desc = "Go to implementation" })
        end
        if client:supports_method("textDocument/references", ev.buf) then
            vim.keymap.set("n", "grr", function()
                require("mini.extra").pickers.lsp({ scope = "references" })
            end, { buffer = ev.buf, desc = "Go to references" })
        end

        if client:supports_method("textDocument/formatting", ev.buf) then
            vim.keymap.set("n", "<leader>f", function()
                vim.lsp.buf.format({ bufnr = ev.buf })
            end, { buffer = ev.buf, desc = "format buffer" })
        end
    end,
})

vim.lsp.config("*", {
    root_markers = { ".git" },
    capabilities = require("mini.completion").get_lsp_capabilities(),
})

vim.lsp.enable({
    "efm",
    "lua_ls",
    "gopls",
    "vtsls",
})
