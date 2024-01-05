return {
    name = "node_tools",
    dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h"),
    dependencies = { "nvim-lua/plenary.nvim" },
    build = "pnpm install",
    config = function(spec)
        local path = require("plenary.path")
        local dir = spec.dir
        local bin_dir = path:new(dir, "node_modules", ".bin")
        if not bin_dir:exists() then
            bin_dir:mkdir({ parents = true })
        end

        vim.env.PATH = vim.env.PATH .. ":" .. bin_dir:absolute()
    end,
}
