local wezterm = require("wezterm")
local pal = require("palette")

local function basename(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local HEADER_ICON_DEFAULT = wezterm.nerdfonts.fa_terminal
local HEADER_ICON_REMOTE = wezterm.nerdfonts.cod_remote
local HEADER_ICONS = {
    -- editor
    nvim = wezterm.nerdfonts.custom_vim,
    vim = wezterm.nerdfonts.custom_vim,
    -- shell
    bash = wezterm.nerdfonts.dev_terminal,
    zsh = wezterm.nerdfonts.dev_terminal,
    fish = wezterm.nerdfonts.dev_terminal,
    -- ssh
    ssh = wezterm.nerdfonts.md_server,
    -- monitor
    top = wezterm.nerdfonts.md_monitor,
    htop = wezterm.nerdfonts.md_monitor,
    btop = wezterm.nerdfonts.md_monitor,
    -- dev tools
    docker = wezterm.nerdfonts.dev_docker,
    podman = wezterm.nerdfonts.dev_docker,
    kubectl = wezterm.nerdfonts.dev_docker,
    node = wezterm.nerdfonts.dev_nodejs_small,
}

local SYMBOL_COLOR = { "#84a0c6", "#6b7089" }
local FONT_COLOR = { pal.NORMAL_FG, "#6b7089" }
local BACK_COLOR = { pal.NORMAL_BG, "#000000" }
local HOVER_COLOR = "#111111"

wezterm.on("format-tab-title", function(tab, _, _, _, hover, _)
    local active = tab.is_active and 1 or 2

    local active_pane_info = tab.active_pane
    local active_pane = wezterm.mux.get_pane(active_pane_info.pane_id)
    local domain_name = active_pane:get_domain_name()
    local is_remote = domain_name ~= "local"

    local process = active_pane_info.foreground_process_name
    local process_name = process and basename(process) or ""
    local cwd_url = active_pane_info.current_working_dir
    local cwd = nil
    if cwd_url then
        if type(cwd_url) == "string" then
            cwd = basename(cwd_url)
        else
            cwd = basename(cwd_url.file_path)
        end
    end

    local bg = hover and HOVER_COLOR or BACK_COLOR[active]

    local index = tab.tab_index + 1
    local zoomed = active_pane_info.is_zoomed and "🔎 " or " "
    local default_icon = is_remote and HEADER_ICON_REMOTE or HEADER_ICON_DEFAULT
    local icon = HEADER_ICONS[process_name] or default_icon

    local title = tab.active_pane.title
    if cwd then
        title = cwd
        if process_name ~= "" then
            title = title .. " | " .. process_name
        end
        if is_remote then
            title = title .. " - " .. domain_name
        end
    end

    return {
        { Background = { Color = bg } },

        { Foreground = { Color = FONT_COLOR[active] } },
        { Text = index .. ": " },

        { Foreground = { Color = SYMBOL_COLOR[active] } },
        { Text = icon .. zoomed },

        { Foreground = { Color = FONT_COLOR[active] } },
        { Text = title },
    }
end)
