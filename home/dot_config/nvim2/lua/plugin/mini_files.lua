local augroup = vim.api.nvim_create_augroup("plugin/mini_files.lua", {})

require("mini.files").setup()

local function map_split(buf_id, key, dir)
    local function action()
        local cur_target = MiniFiles.get_explorer_state().target_window
        local new_target = vim.api.nvim_win_call(cur_target, function()
            vim.cmd(dir .. " split")
            return vim.api.nvim_get_current_win()
        end)

        MiniFiles.set_target_window(new_target)
        MiniFiles.go_in()
    end
    vim.keymap.set("n", key, action, { buffer = buf_id, desc = "Split " .. dir })
end

vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
        local buf_id = args.data.buf_id
        map_split(buf_id, "<C-s>", "horizontal")
        map_split(buf_id, "<C-v>", "vertical")
        map_split(buf_id, "<C-t>", "tab")
    end,
})

vim.api.nvim_create_user_command("Files", function()
    MiniFiles.open()
end, { desc = "Open file exproler" })
vim.keymap.set("n", "<leader>e", "<cmd>Files<cr>", { desc = "Open file exproler" })
