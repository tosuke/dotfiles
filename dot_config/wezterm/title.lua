local wezterm = require("wezterm")
local pal = require("palette")

local HEADER = ""

local SYMBOL_COLOR = { "#b4be82", "#6b7089" }
local FONT_COLOR = pal.NORMAL_FG
local BACK_COLOR = { pal.NORMAL_BG, "#000000" }
local HOVER_COLOR = "#111111"

wezterm.on("format-tab-title", function(tab, _, _, _, hover, _)
    local index = tab.is_active and 1 or 2

    local bg = hover and HOVER_COLOR or BACK_COLOR[index]
    local zoomed = tab.active_pane.is_zoomed and "🔎 " or " "

    return {
        { Foreground = { Color = SYMBOL_COLOR[index] } },
        { Background = { Color = bg } },
        { Text = HEADER .. zoomed },

        { Foreground = { Color = FONT_COLOR } },
        { Background = { Color = bg } },
        { Text = tab.active_pane.title },
    }
end)
