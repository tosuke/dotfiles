local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'iceberg-dark'
config.font =
    wezterm.font('JetBrains Mono')
config.font_size = 13

config.keys = {
    {
        key = ']',
        mods = 'CTRL',
        action = wezterm.action.PaneSelect
    },
}

return config