local not_vscode = function()
    return not vim.g.vscode
end

local plugins = {
    -- self
    "folke/lazy.nvim",
    -- colorscheme
    {
        "cocopon/iceberg.vim",
        cond = not_vscode,
        config = function()
            local augrp = vim.api.nvim_create_augroup("iceberg", { clear = true })
            vim.api.nvim_create_autocmd("ColorScheme", {
                group = augrp,
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
                    for group, conf in pairs(highlight) do
                        vim.api.nvim_set_hl(0, group, conf)
                    end
                end,
            })
        end,
    },
    -- appearance
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        cond = not_vscode,
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
                local gs = require("gitsigns")

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(gs.next_hunk)
                    return "<Ignore>"
                end, { expr = true })

                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(gs.prev_hunk)
                    return "<Ignore>"
                end, { expr = true })

                -- Actions
                map("n", "<leader>hs", gs.stage_hunk)
                map("n", "<leader>hr", gs.reset_hunk)
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                map("n", "<leader>hS", gs.stage_buffer)
                map("n", "<leader>hu", gs.undo_stage_hunk)
                map("n", "<leader>hR", gs.reset_buffer)
                map("n", "<leader>hp", gs.preview_hunk)
                map("n", "<leader>hb", function()
                    gs.blame_line({ full = true })
                end)
                map("n", "<leader>tb", gs.toggle_current_line_blame)
                map("n", "<leader>hd", gs.diffthis)
                map("n", "<leader>hD", function()
                    gs.diffthis("~")
                end)
                map("n", "<leader>td", gs.toggle_deleted)

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
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
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "auto",
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
                    lualine_c = { { "filename", path = 1 } },
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
    -- syntax
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        cmd = { "TSUpdateSync" },
        cond = not_vscode,
        config = function()
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.satysfi = {
                install_info = {
                    url = "https://github.com/monaqa/tree-sitter-satysfi.git",
                    files = { "src/parser.c", "src/scanner.c" },
                },
                filetype = "satysfi",
            }

            require("nvim-treesitter.configs").setup({
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
            })
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
        "machakann/vim-sandwich",
        dependencies = {},
        event = "ModeChanged",
        keys = {
            { "<Plug>(sandwich-add)", mode = { "n", "x" } },
            { "<Plug>(sandwich-delete)", mode = { "n", "x" } },
            { "<Plug>(sandwich-delete-auto)", mode = { "n", "x" } },
            { "<Plug>(sandwich-replace)", mode = { "n", "x" } },
            { "<Plug>(sandwich-replace-auto)", mode = { "n", "x" } },
        },
        init = function()
            vim.g.sandwich_no_default_key_mappings = true

            vim.keymap.set({ "n", "x" }, "sa", "<Plug>(sandwich-add)")
            vim.keymap.set({ "n", "x" }, "sd", "<Plug>(sandwich-delete)")
            vim.keymap.set({ "n", "x" }, "sdb", "<Plug>(sandwich-delete-auto)")
            vim.keymap.set({ "n", "x" }, "sr", "<Plug>(sandwich-replace)")
            vim.keymap.set({ "n", "x" }, "srb", "<Plug>(sandwich-replace-auto)")
        end,
    },
    -- fuzzy finder
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
    -- completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            -- snippet
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip",
            -- autopairs
            "windwp/nvim-autopairs",
        },
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            local cmp = require("cmp")

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
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                }, {
                    { name = "buffer" },
                }),
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
    -- LSP
    {
        "aznhe21/actions-preview.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
        },
        cond = not_vscode,
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        cond = not_vscode,
        dependencies = {
            "b0o/schemastore.nvim",
            "kyoh86/climbdir.nvim",
            "node_tools",
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

            local function disable_format(config)
                return function(spec, c)
                    local conf = {}
                    if type(config) == "function" then
                        conf = config(spec, c)
                    else
                        conf = config
                    end
                    if conf.capabilities == nil then
                        conf.capabilities = vim.lsp.protocol.make_client_capabilities()
                    end
                    conf.capabilities.documentFormattingProvider = false
                    conf.capabilities.documentRangeFormattingProvider = false
                    return conf
                end
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
                    "markdown",
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                    -- shell
                    "fish",
                    "sh",
                },
            })

            -- Go
            setup_lsp(lspcfg.gopls.setup, disable_format({}))

            -- Rust
            setup_lsp(lspcfg.rust_analyzer.setup, {})

            -- OCaml
            setup_lsp(lspcfg.ocamllsp.setup, {})

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
                on_attach = function(_, buf)
                    vim.api.nvim_create_autocmd("BufWritePost", {
                        buffer = buf,
                        callback = function()
                            vim.cmd.Denolscache()
                        end,
                    })
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
            setup_lsp(
                lspcfg.tsserver.setup,
                disable_format({
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
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "literals",
                                includeInlayFunctionParameterTypeHints = true,
                            },
                        },
                    },
                })
            )

            setup_lsp(lspcfg.eslint.setup, {})

            -- Lua
            setup_lsp(lspcfg.lua_ls.setup, {
                flags = {
                    debounce_text_changes = 150,
                },
                settings = {
                    Lua = {
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
            setup_lsp(lspcfg.terraformls.setup, disable_format({}))

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

                    -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bopts)

                    -- definition
                    vim.keymap.set("n", "gd", function()
                        if has_telescope then
                            vim.cmd("Telescope lsp_definitions jump_type=never")
                            return
                        end
                        vim.lsp.buf.definition()
                    end, opts("go to definition"))

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
    -- session
    {
        "jedrzejboczar/possession.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        event = { "BufEnter" },
        config = function()
            local Path = require("plenary.path")
            local session_dir = Path:new(vim.fn.stdpath("state")) / "possession"
            if not session_dir:exists() then
                session_dir:mkdir({ parents = true })
            end
            require("possession").setup({
                session_dir = session_dir:absolute(),
                silent = false,
                load_silent = true,
                debug = false,
                logfile = false,
                prompt_no_cr = false,
                autosave = {
                    current = false,
                    tmp = false,
                    tmp_name = "tmp",
                    on_load = true,
                    on_quit = true,
                },
                commands = {
                    save = "PossessionSave",
                    load = "PossessionLoad",
                    rename = "PossessionRename",
                    close = "PossessionClose",
                    delete = "PossessionDelete",
                    show = "PossessionShow",
                    list = "PossessionList",
                    migrate = "PossessionMigrate",
                },
                hooks = {
                    before_save = function()
                        return {}
                    end,
                    after_save = function() end,
                    before_load = function(_, user_data)
                        return user_data
                    end,
                    after_load = function() end,
                },
                plugins = {
                    close_windows = {
                        hooks = { "before_save", "before_load" },
                        preserve_layout = true,
                        match = {
                            floating = true,
                            buftype = {},
                            filetype = {},
                            custom = false,
                        },
                    },
                    delete_hidden_buffers = {
                        hooks = {
                            "before_load",
                            vim.o.sessionoptions:match("buffer") and "before_save",
                        },
                        force = false,
                    },
                },
                telescope = {
                    previewer = {
                        enabled = true,
                        previewer = "pretty",
                        wrap_lines = true,
                        include_empty_plugin_data = false,
                        -- cwd_colors = { ... }
                    },
                    list = {
                        default_action = "load",
                        mappings = {
                            save = { n = "<c-x>", i = "<c-x>" },
                            load = { n = "<c-v>", i = "<c-v>" },
                            delete = { n = "<c-t>", i = "<c-t>" },
                            rename = { n = "<c-r>", i = "<c-r>" },
                        },
                    },
                },
            })
        end,
    },
}
return plugins
