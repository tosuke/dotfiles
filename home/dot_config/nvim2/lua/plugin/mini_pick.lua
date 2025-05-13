local function window_center_config()
    local height = math.floor(0.6 * vim.o.lines)
    local width = math.floor(0.6 * vim.o.columns)
    return {
        anchor = "NW",
        height = height,
        width = width,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
    }
end

require("mini.pick").setup({
    window = {
        config = window_center_config,
    },
    mappings = {
        choose_marked = "<C-CR>",
        to_qflist = {
            char = "<C-q>",
            func = function()
                local items = MiniPick.get_picker_matches().all
                MiniPick.default_choose_marked(items, { list_type = "qflist" })
            end,
        },
    },
})
vim.ui.select = MiniPick.ui_select

local MiniExtra = require("mini.extra")
for name, f in pairs(MiniExtra.pickers) do
    MiniPick.registry[name] = MiniPick.registry[name] or function(local_opts)
        return f(local_opts)
    end
end

vim.keymap.set("n", "<leader>f", function()
    MiniPick.builtin.files({ tool = "git" })
end, { desc = "mini.pick.files" })

vim.keymap.set("n", "<leader>b", function()
    local function wipeout_cur()
        vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
    end
    MiniPick.builtin.buffers({
        include_current = false,
    }, {
        mappings = {
            wipeout = { char = "<c-d>", func = wipeout_cur },
        },
    })
end, { desc = "mini.pick.buffers" })

require("mini.visits").setup()
vim.keymap.set("n", "<leader>h", function()
    MiniExtra.pickers.visit_paths()
end, { desc = "mini.extra.visit_paths" })

vim.keymap.set("n", "<leader>/", function()
    MiniPick.builtin.grep_live()
end, { desc = "mini.extra.grep_live" })
