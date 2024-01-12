require("title")
local palette = require("palette")

local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- colors
config.color_scheme = "iceberg-dark"
config.window_background_opacity = 0.97
config.colors = {}

-- decorations
config.window_decorations = "RESIZE"

-- font
config.font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "JetBrainsMono" })
config.font_size = 15

-- tab bar
config.use_fancy_tab_bar = true
config.window_frame = {
    font = wezterm.font({ family = "Roboto", weight = "Bold" }),
    font_size = 13.5,

    active_titlebar_bg = '#000000',
    inactive_titlebar_bg = '#000000',
    active_titlebar_fg = palette.NORMAL_FG,
    inactive_titlebar_fg = palette.NORMAL_FG,
    active_titlebar_border_bottom = '#2b2042',
    inactive_titlebar_border_bottom = '#2b2042',

    button_fg = palette.NORMAL_FG,
    button_bg = palette.SURFACE_BG,
}
config.colors.tab_bar = {
    new_tab = {
        bg_color = palette.SURFACE_BG,
        fg_color = palette.NORMAL_FG,
    },
}

-- ime
config.use_ime = true
config.enable_wayland = true

-- key bindings
local keybinds = require("keybinds")
config.disable_default_key_bindings = true
config.leader = { key = "Space", mods = "ALT" }
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables

-- status
config.status_update_interval = 1000
wezterm.on("update-right-status", function(window, pane)
    local name = window:active_key_table()
    if name then
        name = "TABLE: " .. name
    end
    window:set_right_status(name or "")
end)

return config
