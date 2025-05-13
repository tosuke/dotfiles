local clue = require("mini.clue")
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
        clue.gen_clues.registers({ show_contents = true }),
        clue.gen_clues.windows({ submode_resize = true, submode_move = true }),
        clue.gen_clues.z(),
    },
    window = {
        width = "auto",
    },
})
