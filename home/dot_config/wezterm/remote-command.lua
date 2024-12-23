local wezterm = require("wezterm")

local capabilities = {
    ["SSHMUX:tskpc"] = true,
}

wezterm.on("user-var-changed", function(_, pane, name, value)
    if name == "command" then
        if not capabilities[pane:get_domain_name()] then
            return
        end
        local msg = wezterm.serde.json_decode(value)
        if msg.command == "open" then
            wezterm.open_with(msg.url)
        end
    end
end)
