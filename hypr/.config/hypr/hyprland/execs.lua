local home = os.getenv("HOME") or ""

-- Autostart core desktop daemons & services (with singleton locks for idempotency)
hl.on("hyprland.start", function()
    -- Sync session environment with D-Bus and systemd
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")

    -- Notification daemon
    hl.exec_cmd(home .. "/.config/quickshell/scripts/system/notification-start")

    -- Status bar
    hl.exec_cmd(home .. "/.config/quickshell/scripts/system/waybar-start")

    -- Clipboard history watcher
    hl.exec_cmd(home .. "/.config/quickshell/scripts/clipboard/clipboard-start")

    -- Wallpaper daemon & Quickshell rice
    hl.exec_cmd(home .. "/.config/quickshell/scripts/wallpaper/hyprpaper-start")
    hl.exec_cmd("quickshell --no-duplicate -c rice")
end)
