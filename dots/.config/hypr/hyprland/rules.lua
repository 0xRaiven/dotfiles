-- ################# Window & Layer Rules #################

-- --- Window Rules: Floating Dialogs ---
hl.window_rule({ match = { title = "^(Open File)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Select a File)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Choose wallpaper)(.*)$" }, center = true, float = true, size = { "(monitor_w*0.60)", "(monitor_h*0.65)" } })
hl.window_rule({ match = { title = "^(Open Folder)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Save As)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(Library)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(File Upload)(.*)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(.*)(wants to save)$" }, center = true, float = true })
hl.window_rule({ match = { title = "^(.*)(wants to open)$" }, center = true, float = true })

-- --- Window Rules: System Utilities ---
hl.window_rule({
    match = {
        class = "^(pavucontrol|org.pulseaudio.pavucontrol|nm-connection-editor|blueman-manager|zenity|file-roller)$",
    },
    float = true,
    center = true,
})
hl.window_rule({
    match = {
        class = "^(org.kde.polkit-kde-authentication-agent-1|hyprpolkitagent)$",
    },
    float = true,
    center = true,
})

-- --- Window Rules: Picture-in-Picture ---
hl.window_rule({
    match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
    float = true,
    pin = true,
    keep_aspect_ratio = true,
    move = { "(monitor_w*0.73)", "(monitor_h*0.72)" },
    size = { "(monitor_w*0.25)", "(monitor_h*0.25)" },
})

-- --- Window Rules: Screen Sharing Indicator ---
hl.window_rule({
    match = { title = ".*is sharing (a window|your screen).*" },
    float = true,
    pin = true,
    move = { "(monitor_w*0.5-window_w*0.5)", "(monitor_h-window_h-12)" },
})

-- --- Window Rules: Performance & Tearing (Gaming) ---
hl.window_rule({ match = { title = ".*\\.exe" }, immediate = true })
hl.window_rule({ match = { title = ".*minecraft.*" }, immediate = true })
hl.window_rule({ match = { class = "^(steam_app).*" }, immediate = true })

-- --- Window Rules: Shadows ---
hl.window_rule({ match = { float = 0 }, no_shadow = true })

-- ################# Workspace Rules #################
hl.workspace_rule({ workspace = "special:scratchpad", gaps_out = 30 })

-- ################# Layer Rules #################
hl.layer_rule({ match = { namespace = ".*" }, xray = true })
hl.layer_rule({ match = { namespace = "hyprpicker" }, no_anim = true })
hl.layer_rule({ match = { namespace = "selection" }, no_anim = true })

-- Quickshell
hl.layer_rule({ match = { namespace = "quickshell:.*" }, blur = true, blur_popups = true, ignore_alpha = 0.79 })
hl.layer_rule({ match = { namespace = "quickshell:notificationPopup" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "launcher" }, blur = true, ignore_alpha = 0.5 })

-- Desktop notifications & bar
hl.layer_rule({ match = { namespace = "notifications" }, blur = true, ignore_alpha = 0.69 })
hl.layer_rule({ match = { namespace = "waybar" }, blur = true, ignore_alpha = 0.6 })
hl.layer_rule({ match = { namespace = "gtk-layer-shell" }, blur = true, ignore_alpha = 0 })
