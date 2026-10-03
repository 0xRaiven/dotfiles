local home = os.getenv("HOME") or ""
local hypr_dir = home .. "/.config/hypr"
if not package.path:find(hypr_dir, 1, true) then
    package.path = hypr_dir .. "/?.lua;" .. hypr_dir .. "/?/init.lua;" .. package.path
end

-- Core libraries & helper utilities
require("hyprland.lib")

-- Environment variables
require("hyprland.env")
if is_file_exists(HOME .. "/.config/hypr/custom/env.lua") then
    require("custom.env")
end

-- Core default configurations
require("hyprland.execs")
require("hyprland.general")
require("hyprland.monitors")
require("hyprland.rules")
require("hyprland.keybinds")

-- Custom configurations (safe user overrides)
if is_file_exists(HOME .. "/.config/hypr/custom/execs.lua") then
    require("custom.execs")
end
if is_file_exists(HOME .. "/.config/hypr/custom/general.lua") then
    require("custom.general")
end
if is_file_exists(HOME .. "/.config/hypr/custom/monitors.lua") then
    require("custom.monitors")
end
if is_file_exists(HOME .. "/.config/hypr/custom/rules.lua") then
    require("custom.rules")
end
if is_file_exists(HOME .. "/.config/hypr/custom/keybinds.lua") then
    require("custom.keybinds")
end
