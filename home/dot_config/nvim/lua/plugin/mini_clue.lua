local clue = require("mini.clue")
local is_ssh = vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_CLIENT ~= nil

local register_clues = clue.gen_clues.registers({ show_contents = true })
if is_ssh then
    local function replace_clipboard_register_desc(items)
        for _, item in ipairs(items) do
            if type(item) == "table" and type(item.keys) == "string" then
                if item.keys:sub(-1) == "+" then
                    item.desc = "System clipboard"
                elseif item.keys:sub(-1) == "*" then
                    item.desc = "Selection clipboard"
                end
            end

            if vim.islist(item) then
                replace_clipboard_register_desc(item)
            end
        end
    end

    replace_clipboard_register_desc(register_clues)
end

clue.setup({
    triggers = {
        -- Leader
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        { mode = "n", keys = "<LocalLeader>" },
        { mode = "x", keys = "<LocalLeader>" },

        -- Built-in completion
        { mode = "i", keys = "<C-x>" },

        -- `g` key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },

        -- Marks
        { mode = "n", keys = "'" },
        { mode = "x", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "`" },

        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },

        -- Window commands
        { mode = "n", keys = "<C-w>" },

        -- Bracketed commands
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },

        -- `z` key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },

        -- Surround
        { mode = "n", keys = "s" },
        { mode = "x", keys = "s" },

        -- Text Objects
        { mode = "n", keys = "i" },
        { mode = "x", keys = "i" },
        { mode = "n", keys = "a" },
        { mode = "x", keys = "a" },

        -- Option toggle
        { mode = "n", keys = "m" },
    },
    clues = {
        clue.gen_clues.builtin_completion(),
        clue.gen_clues.g(),
        clue.gen_clues.marks(),
        register_clues,
        clue.gen_clues.windows({ submode_resize = true, submode_move = true }),
        clue.gen_clues.z(),
    },
    window = {
        width = "auto",
    },
})
