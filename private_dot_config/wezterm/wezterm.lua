local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'iceberg-dark'
config.font =
    wezterm.font('JetBrains Mono')
config.font_size = 13

config.keys = {
    { key = '[', mods = 'CTRL', action = act.PaneSelect },
    { key = ']', mods = 'CTRL', action = act.PaneSelect { mode = 'SwapWithActive' }, },
    { key = '-', mods = 'CTRL|ALT', action = act.SplitPane { direction = 'Down' }, },
    { key = '\\',mods = 'CTRL|ALT', action = act.SplitPane { direction = 'Right' }, },
}

return config