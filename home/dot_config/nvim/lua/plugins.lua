local is_not_vscode = function()
    return not vim.g.vscode
end

local plugins = {
    "folke/lazy.nvim",
    {
        "cocopon/iceberg.vim",
        cond = is_not_vscode,
        config = function()
            local augroup = vim.api.nvim_create_augroup("iceberg", { clear = true })
            vim.api.nvim_create_autocmd("ColorScheme", {
                group = augroup,
                pattern = "iceberg",
                callback = function()
                    local highlight = {
                        -- rainbow-delimiters
                        --   from cocopon/vscode-iceberg-theme/editorBracketHighlight.*
                        RainbowDelimiter1 = { fg = "#84a0c6" }, -- foreground1
                        RainbowDelimiter2 = { fg = "#89b8c2" }, -- foreground2
                        RainbowDelimiter3 = { fg = "#b4be82" }, -- foreground3
                        RainbowDelimiter4 = { fg = "#e2a478" }, -- foreground4
                        RainbowDelimiter5 = { fg = "#a093c7" }, -- foreground5
                        -- transparent
                        Normal = { ctermbg = "NONE", bg = "NONE" },
                        NonText = { ctermbg = "NONE", bg = "NONE" },
                    }
                    for group, hlconf in pairs(highlight) do
                        vim.api.nvim_set_hl(0, group, hlconf)
                    end
                end,
            })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        cond = is_not_vscode,
        opts = {
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signcolumn = true,
            numhl = false,
            linehl = false,
            word_diff = false,
            watch_gitdir = {
                follow_files = true,
            },
            attach_to_untracked = true,
            current_line_blame = false,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 1000,
                ignore_whitespace = false,
                virt_text_priority = 100,
            },
            current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil,
            max_file_length = 40000,
            preview_config = {
                border = "single",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
            yadm = { enable = false },
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function keymap(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                keymap("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(gitsigns.next_hunk)
                    return "<Ignore>"
                end, { expr = true })

                keymap("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(gitsigns.prev_hunk)
                    return "<Ignore>"
                end, { expr = true })

                -- Actions
                keymap("n", "<leader>hs", gitsigns.stage_hunk)
                keymap("n", "<leader>hr", gitsigns.reset_hunk)
                keymap("v", "<leader>hs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                keymap("v", "<leader>hr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                keymap("n", "<leader>hS", gitsigns.stage_buffer)
                keymap("n", "<leader>hu", gitsigns.undo_stage_hunk)
                keymap("n", "<leader>hR", gitsigns.reset_buffer)
                keymap("n", "<leader>hp", gitsigns.preview_hunk)
                keymap("n", "<leader>hb", function()
                    gitsigns.blame_line({ full = true })
                end)
                keymap("n", "<leader>tb", gitsigns.toggle_current_line_blame)
                keymap("n", "<leader>hd", gitsigns.diffthis)
                keymap("n", "<leader>hD", function()
                    gitsigns.diffthis("~")
                end)
                keymap("n", "<leader>td", gitsigns.toggle_deleted)

                -- Text object
                keymap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
        },
    },
    {
        "linrongbin16/gitlinker.nvim",
        cmd = "GitLink",
        opts = {},
        keys = {
            { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local function diff_source()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed,
                    }
                end
            end
            local filename = { "filename", path = 1 }
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "iceberg_dark",
                    disabled_filetypes = { "TelescopePrompt" },
                    always_devide_middle = true,
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        { "b:gitsigns_head", icon = "" },
                        { "diff", source = diff_source },
                        "diagnostics",
                    },
                    lualine_c = { filename },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },
    {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = { "BufEnter" },
        config = function()
            local lsp_lines = require("lsp_lines")
            lsp_lines.setup()

            vim.keymap.set("n", "<leader>l", lsp_lines.toggle, { silent = true, desc = "Toggle lsp lines" })
        end,
    },
    {
        "j-hui/fidget.nvim",
        event = { "VeryLazy" },
        opts = {},
    },
    {
        "norcalli/nvim-colorizer.lua",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("colorizer").setup()
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        cmd = { "TSUpdateSync" },
        cond = is_not_vscode,
        opts = {
            auto_install = true,
            highlight = {
                enable = true,
                disable = { "vimdoc", "dockerfile" },
            },
            indent = {
                enable = true,
                disable = { "ocaml" },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Auto jump to textobj
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                move = {
                    enable = true,
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer",
                    },
                },
            },
        },
        config = function(_, opts)
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.satysfi = {
                install_info = {
                    url = "https://github.com/monaqa/tree-sitter-satysfi.git",
                    files = { "src/parser.c", "src/scanner.c" },
                },
                filetype = "satysfi",
            }

            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    {
        "earthly/earthly.vim",
        ft = { "Earthfile" },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            enable = true,
            max_lines = 0, -- unlimited
            min_window_height = 20,
            line_numbers = true,
            multiline_threshold = 10,
            trim_scope = "outer",
            mode = "cursor",
            separator = nil,
            zindex = 20,
            on_attach = nil,
        },
        config = function(_, opts)
            local treesitter_context = require("treesitter-context")
            treesitter_context.setup(opts)

            vim.keymap.set("n", "[C", treesitter_context.go_to_context, { silent = true })
        end,
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local rd = require("rainbow-delimiters")
            require("rainbow-delimiters.setup").setup({
                strategy = {
                    [""] = rd.strategy["global"],
                    vim = rd.strategy["local"],
                },
                query = {
                    [""] = "rainbow-delimiters",
                    lua = "rainbow-blocks",
                },
                priority = {
                    [""] = 110,
                    lua = 210,
                },
                highlight = {
                    "RainbowDelimiter1",
                    "RainbowDelimiter2",
                    "RainbowDelimiter3",
                    "RainbowDelimiter4",
                    "RainbowDelimiter5",
                },
            })
        end,
    },
    {
        "windwp/nvim-autopairs",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = "InsertEnter",
        config = function()
            local npairs = require("nvim-autopairs")
            npairs.setup({
                check_ts = true,
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = "InsertEnter",
        opts = {},
    },
    {
        "machakann/vim-sandwich",
        dependencies = {},
        event = "ModeChanged",
        keys = {
            { "<Plug>(sandwich-add)", mode = { "n", "x", "o" } },
            { "<Plug>(sandwich-delete)", mode = { "n", "x" } },
            { "<Plug>(sandwich-delete-auto)", mode = { "n" } },
            { "<Plug>(sandwich-replace)", mode = { "n", "x" } },
            { "<Plug>(sandwich-replace-auto)", mode = { "n" } },
            { "<Plug>(textobj-sandwich-auto-i)", mode = { "o", "x" } },
            { "<Plug>(textobj-sandwich-auto-a)", mode = { "o", "x" } },
            { "<Plug>(textobj-sandwich-query-i)", mode = { "o", "x" } },
            { "<Plug>(textobj-sandwich-query-a)", mode = { "o", "x" } },
        },
        init = function()
            vim.g.sandwich_no_default_key_mappings = true

            vim.keymap.set({ "n", "x", "o" }, "sa", "<Plug>(sandwich-add)")
            vim.keymap.set({ "n", "x" }, "sd", "<Plug>(sandwich-delete)")
            vim.keymap.set({ "n" }, "sdb", "<Plug>(sandwich-delete-auto)")
            vim.keymap.set({ "n", "x" }, "sr", "<Plug>(sandwich-replace)")
            vim.keymap.set({ "n" }, "srb", "<Plug>(sandwich-replace-auto)")

            vim.keymap.set({ "o", "x" }, "ib", "<Plug>(textobj-sandwich-auto-i)")
            vim.keymap.set({ "o", "x" }, "ab", "<Plug>(textobj-sandwich-auto-a)")
            vim.keymap.set({ "o", "x" }, "is", "<Plug>(textobj-sandwich-query-i)")
            vim.keymap.set({ "o", "x" }, "as", "<Plug>(textobj-sandwich-query-a)")

            vim.g["sandwich#recipes"] = vim.deepcopy(vim.g["sandwich#default_recipes"])
        end,
    },
    {
        "numToStr/Comment.nvim",
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                opts = {
                    enable_autocmd = false,
                },
            },
        },
        keys = {
            { "gc", mode = { "n", "x" } },
        },
        config = function()
            require("Comment").setup({
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
                post_hook = nil,
                padding = true,
                sticky = true,
                ignore = nil,
                toggler = {
                    line = "gcc",
                    block = "gbc",
                },
                opleader = {
                    line = "gc",
                    block = "gb",
                },
                extra = {
                    above = "gc0",
                    below = "gco",
                    eol = "gcA",
                },
                mappings = {
                    basic = true,
                    extra = false,
                },
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = { "Telescope" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-telescope/telescope-file-browser.nvim",
            "lewis6991/gitsigns.nvim",
            "jedrzejboczar/possession.nvim",
        },
        init = function()
            -- keymaps
            vim.keymap.set(
                "n",
                "<leader><leader>",
                "<cmd>Telescope find_files hidden=true<cr>",
                { silent = true, desc = "find files" }
            )
            vim.keymap.set(
                "n",
                "<leader>gg",
                "<cmd>Telescope live_grep hidden=true<cr>",
                { silent = true, desc = "[G]rep" }
            )
            vim.keymap.set(
                "n",
                "<leader>gs",
                "<cmd>Telescope git_status<cr>",
                { silent = true, desc = "[G]it [S]tatus" }
            )
            vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>", { silent = true, desc = "find [B]uffers" })
            vim.keymap.set(
                "n",
                "<leader>ex",
                "<cmd>Telescope file_browser path=%:p:h select_buffer=true hidden=true<cr>",
                { silent = true, desc = "File [Ex]plorer" }
            )
            -- colors
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "iceberg",
                callback = function()
                    local bg_float = "#1e2132"
                    local bg_selection = "#2a3158"
                    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = bg_selection })
                    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = bg_float })
                    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = bg_float })
                    vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = bg_float })
                    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = bg_float })
                    vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = bg_float })
                    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = bg_float })
                end,
            })
        end,
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            telescope.setup({
                defaults = {
                    winblend = 10,
                    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                    color_devicons = true,
                    file_ignore_patterns = { "node%_modules/.*", "%.git/.*", "%.cache/.*", "%.npm/.*" },
                    layout_strategy = "vertical",
                    mappings = {
                        i = {
                            ["<C-h>"] = actions.which_key,
                        },
                    },
                },

                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--smart-case",
                    "-uu",
                },

                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    file_browser = {
                        theme = "ivy",
                    },
                },
            })
            telescope.load_extension("fzf")
            telescope.load_extension("file_browser")
            telescope.load_extension("possession")
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            {
                "zbirenbaum/copilot-cmp",
                dependencies = { "zbirenbaum/copilot.lua" },
                config = function()
                    require("copilot_cmp").setup()
                end,
            },
            -- snippet
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip",
            -- icons
            "onsails/lspkind-nvim",

            "windwp/nvim-autopairs",
        },
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            local cmp = require("cmp")

            local function has_word_before()
                if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
                    return false
                end
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
            end

            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<Tab>"] = vim.schedule_wrap(function(fallback)
                        if cmp.visible() and has_word_before() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    }),
                }),
                formatting = {
                    format = require("lspkind").cmp_format({
                        mode = "symbol",
                        max_width = 50,
                        preset = "codicons",
                        symbol_map = {
                            Copilot = "",
                        },
                    }),
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "copilot" },
                    { name = "vsnip" },
                    { name = "nvim_lsp_signature_help" },
                }, {
                    { name = "buffer" },
                }),
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        require("copilot_cmp.comparators").prioritize,
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })

            -- 補完後に括弧類を挿入する
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        cond = is_not_vscode,
        commands = { "Copilot" },
        event = { "InsertEnter" },
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            "zbirenbaum/copilot.lua",
            "nvim-lua/plenary.nvim",
        },
        cmd = { "CopilotChat" },
        build = "make tiktoken",
        config = function()
            local select = require("CopilotChat.select")
            require("CopilotChat").setup({
                show_help = "yes",
                model = "claude-3.5-sonnet",
                prompts = {
                    Explain = {
                        prompt = "/COPILOT_EXPLAIN コードを日本語で説明してください",
                        description = "Explain code",
                    },
                    Review = {
                        prompt = "/COPILOT_REVIEW コードを日本語でレビューしてください",
                        description = "Review code",
                    },
                    Fix = {
                        prompt = "/COPILOT_GENERATE このコードには問題があります。バグを修正してください。",
                        description = "Fix code",
                    },
                    FixDiagnostic = {
                        prompt = "/COPILOT_GENERATE 次のような診断上の問題を解決して修正してください。",
                        selection = select.diagnostics,
                    },
                },
            })
        end,
    },
    {
        "aznhe21/actions-preview.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
        },
        cond = is_not_vscode,
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        cond = is_not_vscode,
        dependencies = {
            "b0o/schemastore.nvim",
            "kyoh86/climbdir.nvim",
            "python_tools",
            "hrsh7th/cmp-nvim-lsp",
        },
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lspcfg = require("lspconfig")
            local cmplsp = require("cmp_nvim_lsp")

            local function setup_lsp(setup, config)
                local cap = vim.lsp.protocol.make_client_capabilities()
                local conf = { capabilities = cap }
                if type(config) == "function" then
                    conf = config(setup, conf)
                else
                    conf = config
                end
                conf.capabilities = cmplsp.default_capabilities(conf.capabilities)
                setup(conf)
            end

            -- efm
            setup_lsp(lspcfg.efm.setup, {
                init_options = {
                    documentFormatting = true,
                    rangeFormatting = true,
                    hover = true,
                    documentSymbol = true,
                    codeAction = true,
                    completion = true,
                },
                filetypes = {
                    "lua",
                    "go",
                    "ocaml",
                    -- config
                    "json",
                    "jsonc",
                    "yaml",
                    "terraform",
                    -- web
                    "html",
                    "css",
                    "markdown",
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                    -- shell
                    "fish",
                    "sh",
                    -- other
                    "typst",
                },
            })

            -- Go
            setup_lsp(lspcfg.gopls.setup, {
                on_attach = function(client)
                    -- diable formatting
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
            })
            setup_lsp(lspcfg.golangci_lint_ls.setup, {})

            -- Rust
            setup_lsp(lspcfg.rust_analyzer.setup, {
                on_attach = function(client)
                    -- disable semantic tokens
                    client.server_capabilities.semanticTokensProvider = nil
                end,
            })

            -- Scala
            setup_lsp(lspcfg.metals.setup, {})

            -- OCaml
            setup_lsp(lspcfg.ocamllsp.setup, {
                settings = {
                    extendedHover = {
                        enable = true,
                    },
                    duneDiagnostics = {
                        enable = true,
                    },
                },
                on_attach = function(client, _)
                    -- disable formatting
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    -- disable semantic tokens
                    client.server_capabilities.semanticTokensProvider = nil
                end,
            })

            -- Haskell
            setup_lsp(lspcfg.hls.setup, {})

            -- TypeScript
            setup_lsp(lspcfg.denols.setup, {
                single_file_support = false,
                root_dir = function(path)
                    local marker = require("climbdir.marker")
                    local found = require("climbdir").climb(
                        path,
                        marker.one_of(marker.has_readable_file("deno.json"), marker.has_readable_file("deno.jsonc")),
                        {
                            halt = marker.one_of(marker.has_readable_file("package.json")),
                        }
                    )
                    return found
                end,
                on_attach = function(client, buf)
                    vim.api.nvim_create_autocmd("BufWritePost", {
                        buffer = buf,
                        callback = function()
                            vim.cmd.DenolsCache()
                        end,
                    })
                    -- disable semantic tokens
                    client.server_capabilities.semanticTokensProvider = nil
                end,
                settings = {
                    deno = {
                        lint = true,
                        suggest = {
                            imports = {
                                hosts = {
                                    ["https://deno.land"] = true,
                                    ["https://esm.sh"] = true,
                                },
                            },
                        },
                    },
                },
            })
            setup_lsp(lspcfg.ts_ls.setup, {
                single_file_support = false,
                root_dir = function(path)
                    local marker = require("climbdir.marker")
                    local found = require("climbdir").climb(
                        path,
                        marker.one_of(
                            marker.has_readable_file("tsconfig.json"),
                            marker.has_readable_file("jsconfig.json"),
                            marker.has_readable_file("package.json"),
                            marker.has_directory("node_modules")
                        ),
                        {
                            halt = marker.one_of(
                                marker.has_readable_file("deno.json"),
                                marker.has_readable_file("deno.jsonc")
                            ),
                        }
                    )
                    return found
                end,
                on_attach = function(client)
                    -- disable semantic tokens
                    client.server_capabilities.semanticTokensProvider = nil
                    -- disable formatting
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "literals",
                            includeInlayFunctionParameterTypeHints = true,
                        },
                    },
                },
            })

            -- ESLint
            setup_lsp(lspcfg.eslint.setup, {})

            -- Biome
            setup_lsp(lspcfg.biome.setup, {})

            -- TailwindCSS
            setup_lsp(lspcfg.tailwindcss.setup, {})

            -- Lua
            setup_lsp(lspcfg.lua_ls.setup, {
                flags = {
                    debounce_text_changes = 150,
                },
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                            pathStrict = true,
                            path = { "?.lua", "?/init.lua" },
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        completion = {
                            showWord = "disable",
                            callSnippet = "Replace",
                        },
                        format = {
                            enable = false,
                        },
                        hint = {
                            enable = true,
                        },
                        semantic = {
                            enable = false,
                        },
                    },
                },
            })

            -- json
            setup_lsp(lspcfg.jsonls.setup, function(_, config)
                config.init_options = {
                    provideFormatter = false,
                }
                config.capabilities.textDocument.completion.completionItem.snippetSupport = true
                config.settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                        format = { enable = false },
                    },
                }
                return config
            end)

            -- yaml
            setup_lsp(lspcfg.yamlls.setup, {
                settings = {
                    yaml = {
                        schemas = require("schemastore").yaml.schemas(),
                        validate = false,
                        hover = true,
                        completion = true,
                        format = { enable = false },
                    },
                },
            })

            -- terraform
            setup_lsp(lspcfg.terraformls.setup, {
                on_attach = function(client)
                    -- disable formatting
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    -- disable semantic tokens
                    client.server_capabilities.semanticTokensProvider = false
                end,
            })

            -- Protocol Buffers
            setup_lsp(lspcfg.buf_ls.setup, {})

            -- Typst
            setup_lsp(lspcfg.tinymist.setup, {})

            -- keymaps
            local has_telescope = require("lazy.core.config").spec.plugins["telescope.nvim"] ~= nil
            local has_actions_preview = require("lazy.core.config").spec.plugins["actions-preview.nvim"] ~= nil
            local group = vim.api.nvim_create_augroup("UserLspConfig", {})
            vim.api.nvim_create_autocmd("LspAttach", {
                group = group,
                callback = function(ev)
                    local function opts(desc)
                        return { silent = true, buffer = ev.buf, desc = desc }
                    end

                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("hover"))

                    -- definition
                    vim.keymap.set("n", "gd", function()
                        if has_telescope then
                            vim.cmd("Telescope lsp_definitions jump_type=never")
                            return
                        end
                        vim.lsp.buf.definition()
                    end, opts("go to definition"))

                    -- declaration
                    vim.keymap.set("n", "gD", function()
                        vim.lsp.buf.declaration()
                    end, opts("go to declaration"))

                    -- type definition
                    vim.keymap.set("n", "gt", function()
                        if has_telescope then
                            vim.cmd("Telescope lsp_type_definitions jump_type=never")
                            return
                        end
                        vim.lsp.buf.type_definition()
                    end, opts("go to type definition"))

                    -- implementation
                    vim.keymap.set("n", "gi", function()
                        if has_telescope then
                            vim.cmd("Telescope lsp_implementations jump_type=never")
                            return
                        end
                        vim.lsp.buf.implementation()
                    end, opts("go to implementation"))

                    -- references
                    vim.keymap.set("n", "gr", function()
                        if has_telescope then
                            vim.cmd("Telescope lsp_references jump_type=never")
                            return
                        end
                        vim.lsp.buf.references()
                    end)

                    -- signature help
                    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts("signature help"))
                    vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, opts("signature help"))

                    -- diagnostics
                    vim.keymap.set("n", "<leader>q", function()
                        if has_telescope then
                            vim.cmd("Telescope diagnostics")
                            return
                        end
                        vim.diagnostic.setloclist()
                    end, opts("open diagnostics"))
                    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts("open diagnostic float"))
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("goto prev diagnostic"))
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts("goto next diagnostic"))

                    -- rename
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("rename"))

                    -- code actions
                    vim.keymap.set("n", "<leader>ca", function()
                        if has_actions_preview then
                            require("actions-preview").code_actions()
                            return
                        end
                        vim.lsp.buf.code_action()
                    end, opts("code actions"))

                    vim.keymap.set("n", "<leader>f", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts("format"))

                    -- workspace
                    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("add workspace folder"))
                    vim.keymap.set(
                        "n",
                        "<leader>wr",
                        vim.lsp.buf.remove_workspace_folder,
                        opts("remove workspace folder")
                    )
                    vim.keymap.set("n", "<leader>wl", function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts("list workspace folders"))
                end,
            })
        end,
    },
    {
        "Julian/lean.nvim",
        event = { "BufReadPost *.lean", "BufNewFile *.lean" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
        },
        opts = {
            lsp = {},
            abbreviations = {
                enable = true,
                leader = "\\",
            },
            mappings = true,
        },
    },
    {
        "chomosuke/typst-preview.nvim",
        cmd = {
            "TypstPreview",
            "TypstPreviewUpdate",
            "TypstPreviewStop",
            "TypstPreviewToggle",
            "TypstPreviewFollowCursor",
            "TypstPreviewNoFollowCursor",
            "TypstPreviewFollowCursorToggle",
            "TypstPreviewSyncCursor",
        },
        opts = {
            dependencies_bin = {
                -- Managed by aqua
                ["tinymist"] = "tinymist",
                ["websocat"] = "websocat",
            },
        },
    },
}
return plugins
