return {
    name = "python_tools",
    dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h"),
    dependencies = { "nvim-lua/plenary.nvim" },
    build = "rye sync",
    config = function(spec)
        local path = require("plenary.path")
        local bin_dir = path:new(spec.dir, ".venv", "bin"):absolute()
        vim.env.PATH = vim.env.PATH .. ":" .. bin_dir
    end,
}
