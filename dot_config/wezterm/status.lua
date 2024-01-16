local wezterm = require("wezterm")
local palette = require("palette")

local function add_elem(elems, header, str)
    table.insert(elems, { Foreground = header.Foreground })
    table.insert(elems, { Background = { Color = palette.NORMAL_BG } })
    table.insert(elems, { Text = header.Text .. "  " })

    table.insert(elems, { Foreground = { Color = palette.NORMAL_FG } })
    table.insert(elems, { Background = { Color = palette.NORMAL_BG } })
    table.insert(elems, { Text = str .. "   " })
end

local HEADER_KEYTABLE = { Foreground = { Color = "#c0ca8e" }, Text = wezterm.nerdfonts.md_keyboard }
local function get_keytable(elems, window)
    local name = window:active_key_table()
    if not name then
        return
    end
    add_elem(elems, HEADER_KEYTABLE, name)
end

local HEADER_HOST = { Foreground = { Color = "#75b1a9" }, Text = wezterm.nerdfonts.md_monitor }
local HEADER_CWD = { Foreground = { Color = "#75b1a9" }, Text = wezterm.nerdfonts.md_folder }
local function get_host_and_cwd(elems, pane)
    local uri = pane:get_current_working_dir()
    if not uri then
        return
    end

    local host = ""
    local cwd = ""

    if type(uri) == "string" then
        host = uri:gsub("^file://([^/]+)/.*$", "%1")
        cwd = uri:gsub("^file://[^/]+", ""):gsub("^/home/tosuke", "~")
    else
        host = uri.host
        cwd = uri.file_path:gsub("^/home/tosuke", "~")
    end

    add_elem(elems, HEADER_HOST, host)
    add_elem(elems, HEADER_CWD, cwd)
end

local function update_left(window, _)
    local elems = {}

    get_keytable(elems, window)

    window:set_left_status(wezterm.format(elems))
end

local function update_right(window, pane)
    local elems = {}

    get_host_and_cwd(elems, pane)

    window:set_right_status(wezterm.format(elems))
end

wezterm.on("update-status", function(window, pane)
    update_left(window, pane)
    update_right(window, pane)
end)
