vim.cmd.packadd("copilot.lua")
require("copilot").setup({
    suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
            accept = "<c-e>",
            accept_word = "<c-g><c-e>",
            next = "<c-f>",
            prev = "<c-b>",
            dismiss = "<c-d>",
        },
    },
    panel = { enabled = true },

    copilot_model = "gpt-4o-copilot",
    filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = true,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["*"] = true,
    },
    should_attach = function(_, bufname)
        if string.match(bufname, "env") then
            return false
        end

        return true
    end,

    server = {
        type = "binary",
        custom_server_filepath = "copilot-language-server",
    },
})

local augroup = vim.api.nvim_create_augroup("plugin/copilot.lua", {})

local function apply_copilot_highlight()
    vim.api.nvim_set_hl(
        0,
        "CopilotSuggestion",
        vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = "Comment" }), { underline = true })
    )
end

apply_copilot_highlight()
vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup,
    pattern = "*",
    callback = apply_copilot_highlight,
})
