require("mini.misc").setup()

MiniMisc.setup_restore_cursor()
-- https://github.com/echasnovski/mini.nvim/issues/1955
-- MiniMisc.setup_termbg_sync()

vim.api.nvim_create_user_command("Zoom", function()
    MiniMisc.zoom(0, {})
end, { desc = "Zoom current buffer" })
vim.keymap.set("n", "mz", "<cmd>Zoom<cr>", { desc = "Zoom current buffer" })

