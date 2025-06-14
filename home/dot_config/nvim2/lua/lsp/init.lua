-- load lspconfig
vim.cmd.packadd("nvim-lspconfig")

local efm = require("lsp.efm")
local utils = require("lsp.utils")

local augroup = vim.api.nvim_create_augroup("lsp/init.lua", {})

---@param client vim.lsp.Client
---@param bufnr number
local function register_keymap(client, bufnr)
    require("plugin.mini_pick")

    if client:supports_method("textDocument/hover", bufnr) then
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover" })
    end
    if client:supports_method("textDocument/signatureHelp", bufnr) then
        vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
        vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
    end

    if client:supports_method("textDocument/definition", bufnr) then
        vim.keymap.set("n", "gd", function()
            require("mini.extra").pickers.lsp({ scope = "definition" })
        end, { buffer = bufnr, desc = "Go to definition" })
    end
    if client:supports_method("textDocument/declaration", bufnr) then
        vim.keymap.set("n", "gD", function()
            require("mini.extra").pickers.lsp({ scope = "declaration" })
        end, { buffer = bufnr, desc = "Go to declaration" })
    end
    if client:supports_method("textDocument/typeDefinition", bufnr) then
        vim.keymap.set("n", "grt", function()
            require("mini.extra").pickers.lsp({ scope = "type_definition" })
        end, { buffer = bufnr, desc = "Go to type definition" })
    end
    if client:supports_method("textDocument/implementation", bufnr) then
        vim.keymap.set("n", "gri", function()
            require("mini.extra").pickers.lsp({ scope = "implementation" })
        end, { buffer = bufnr, desc = "Go to implementation" })
    end
    if client:supports_method("textDocument/references", bufnr) then
        vim.keymap.set("n", "grr", function()
            require("mini.extra").pickers.lsp({ scope = "references" })
        end, { buffer = bufnr, desc = "Go to references" })
    end

    local function set_format_keymap(mode)
        vim.keymap.set(mode, "<LocalLeader>f", function()
            utils.format_buf(bufnr)
        end, { buffer = bufnr, desc = "Format" })
    end
    if client:supports_method("textDocument/formatting", bufnr) then
        set_format_keymap("n")
    end
    if client:supports_method("textDocument/rangeFormatting", bufnr) then
        set_format_keymap("x")
    end

    if client:supports_method("textDocument/documentSymbol", bufnr) then
        vim.keymap.set("n", "<LocalLeader>s", function()
            require("mini.extra").pickers.lsp({ scope = "document_symbol" })
        end, { buffer = bufnr, desc = "Document Symbols" })
    end
    if client:supports_method("workspace/symbol", bufnr) then
        vim.keymap.set("n", "<Leader>s", function()
            require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
        end, { buffer = bufnr, desc = "Workspace Symbols" })
    end

    if client:supports_method("textDocument/inlayHint", bufnr) then
        ---@type vim.lsp.inlay_hint.enable.Filter
        local filter = { bufnr = bufnr }
        vim.lsp.inlay_hint.enable(true, filter)

        vim.keymap.set("n", "mH", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
        end, { buffer = bufnr, desc = "Toggle Inlay Hints" })
    end
end

local original_register_capability = vim.lsp.handlers["client/registerCapability"]
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.handlers["client/registerCapability"] = function(err, result, ctx, config)
    local origResult = original_register_capability(err, result, ctx, config)

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
        return origResult
    end

    register_keymap(client, ctx.bufnr)
    return origResult
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        register_keymap(client, ev.buf)
    end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup,
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })
    end,
})

vim.lsp.config("*", {
    root_markers = { ".git" },
    capabilities = require("mini.completion").get_lsp_capabilities(),
})

efm.setup()
vim.lsp.enable({
    "lua_ls",
    "gopls",
    "vtsls",
    "rust_analyzer",
    "biome",
    "tinymist",

    "jsonls",
    "yamlls",
    "gh_actions_ls",
})
