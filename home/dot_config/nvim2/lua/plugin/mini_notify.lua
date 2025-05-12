local MiniNotify = require("mini.notify")

local win_config = function()
    local has_statusline = vim.o.laststatus > 0
    local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
    return { anchor = "SE", col = vim.o.columns, row = vim.o.lines - pad }
end
MiniNotify.setup({
    window = {
        config = win_config,
    },
})
vim.notify = MiniNotify.make_notify()

vim.api.nvim_create_user_command("NotifyHistory", function()
    MiniNotify.show_history()
end, { desc = "Show notify history" })

