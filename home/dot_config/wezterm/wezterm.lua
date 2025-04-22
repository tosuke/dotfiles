require("title")
require("status")
require("remote-command")
local palette = require("palette")

local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- colors
config.color_scheme = "iceberg-dark"
config.window_background_opacity = 0.85
config.text_background_opacity = 0.7
config.colors = {}
config.inactive_pane_hsb = {
    saturation = 0.6,
    brightness = 0.8,
}

-- decorations
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

-- font
config.font = wezterm.font_with_fallback({
    { family = "JetBrainsMono Nerd Font" },
    { family = "BIZ UDGothic" },
})
config.font_size = 14

-- tab bar
config.use_fancy_tab_bar = true
config.window_frame = {
    font = wezterm.font({ family = "Roboto", weight = "Bold" }),
    font_size = 13.5,

    active_titlebar_bg = "#000000",
    inactive_titlebar_bg = "#000000",
    active_titlebar_fg = palette.NORMAL_FG,
    inactive_titlebar_fg = palette.NORMAL_FG,

    button_fg = palette.NORMAL_FG,
    button_bg = palette.SURFACE_BG,
}
config.colors.tab_bar = {
    inactive_tab_edge = palette.NORMAL_FG,
    new_tab = {
        bg_color = palette.SURFACE_BG,
        fg_color = palette.NORMAL_FG,
    },
}

-- visual bell
config.audible_bell = "Disabled"
config.visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
}
config.colors.visual_bell = "#202020"

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

return config
