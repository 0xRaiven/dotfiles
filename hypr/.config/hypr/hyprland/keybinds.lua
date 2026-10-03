-- Keybindings configuration
local home = os.getenv("HOME") or ""

local apps = {
    terminal = "kitty",
    launcher = "quickshell --no-duplicate -c launcher",
    file_manager = "nautilus",
    browser = "zen-browser",
    editor = "code",
    antigravity = home .. "/Desktop/AntigravityIDE/antigravity-ide",
    clipboard = "env LAUNCHER_INITIAL_QUERY=: quickshell --no-duplicate -c launcher",
}

-- --- Applications ---
bind("SUPER + T", hl.dsp.exec_cmd(apps.terminal))
bind("SUPER + W", hl.dsp.exec_cmd(apps.browser))
bind("SUPER + SUPER_L", hl.dsp.exec_cmd(apps.launcher), { release = true })
bind("SUPER + E", hl.dsp.exec_cmd(apps.file_manager))
bind("SUPER + C", hl.dsp.exec_cmd(apps.editor))
bind("SUPER + A", hl.dsp.exec_cmd(apps.antigravity))
bind("SUPER + V", hl.dsp.exec_cmd(apps.clipboard))

-- --- Window Management ---
bind("SUPER + Q", hl.dsp.window.close())
bind("SUPER + SHIFT + Q", hl.dsp.exit())
bind("SUPER + F", hl.dsp.window.fullscreen())
bind("SUPER + SPACE", hl.dsp.window.float({ action = "toggle" }))
bind("SUPER + TAB", hl.dsp.window.cycle_next())
bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- --- Navigation & Focus (Arrow Keys) ---
bind("SUPER + Left", hl.dsp.focus({ direction = "l" }))
bind("SUPER + Right", hl.dsp.focus({ direction = "r" }))
bind("SUPER + Up", hl.dsp.focus({ direction = "u" }))
bind("SUPER + Down", hl.dsp.focus({ direction = "d" }))

bind("SUPER + SHIFT + Left", hl.dsp.window.move({ direction = "l" }))
bind("SUPER + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
bind("SUPER + SHIFT + Up", hl.dsp.window.move({ direction = "u" }))
bind("SUPER + SHIFT + Down", hl.dsp.window.move({ direction = "d" }))

bind("SUPER + CTRL + Left", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -30 0"))
bind("SUPER + CTRL + Right", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 30 0"))
bind("SUPER + CTRL + Up", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -30"))
bind("SUPER + CTRL + Down", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 30"))

-- --- Mouse Window Drag & Resize ---
bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- --- Workspaces (1 to 10 with modulo mapping: 10 -> 0) ---
for i = 1, 10 do
    local key = tostring(i % 10)
    bind("SUPER + " .. key, hl.dsp.focus({ workspace = tostring(i) }))
    bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(i) }))
end

-- Workspace Cycling
bind("SUPER + BracketLeft", hl.dsp.focus({ workspace = "e-1" }))
bind("SUPER + BracketRight", hl.dsp.focus({ workspace = "e+1" }))

-- Scratchpad (Special Workspace)
bind("SUPER + S", hl.dsp.workspace.toggle_special("scratchpad"))
bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- --- Hardware Controls & Utilities ---
bind("PRINT", hl.dsp.exec_cmd(home .. "/.config/quickshell/scripts/system/screenshot region"))
bind("SHIFT + PRINT", hl.dsp.exec_cmd(home .. "/.config/quickshell/scripts/system/screenshot full"))
bind("SUPER + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- Audio
bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true })
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true })
bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Brightness
bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true })
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true })
