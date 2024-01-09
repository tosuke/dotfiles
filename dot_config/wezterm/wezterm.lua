local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

local ssh_domains = {}
for host, conf in pairs(wezterm.enumerate_ssh_hosts()) do
    table.insert(ssh_domains, {
        name = host,
        remote_address = conf["hostname"],
        username = conf["user"],
        assume_shell = "Posix",
    })
end
config.ssh_domains = ssh_domains

config.color_scheme = "iceberg-dark"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 15

config.use_ime = true
config.ime_preedit_rendering = "Builtin" -- FIXME: Builtin にしても System にしても fcitx5 はうまく動いてくれない
config.enable_wayland = false

local keybinds = require("keybinds")
config.disable_default_key_bindings = true
config.leader = { key = "Space", mods = "CTRL|SHIFT" }
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables

return config
