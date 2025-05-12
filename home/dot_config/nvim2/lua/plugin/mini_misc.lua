require("mini.misc").setup()

MiniMisc.setup_restore_cursor()
MiniMisc.setup_termbg_sync()

vim.api.nvim_create_user_command("Zoom", function()
    MiniMisc.zoom(0, {})
end, { desc = "Zoom current buffer" })
vim.keymap.set("n", "mz", "<cmd>Zoom<cr>", { desc = "Zoom current buffer" })

