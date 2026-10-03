local constants = require("config.constants")

hl.env("XCURSOR_SIZE", constants.cursor_size)

-- Enable native Wayland for Electron apps (VS Code, Antigravity IDE, etc.)
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("NIXOS_OZONE_WL", "1")

-- Standard Wayland environment defaults
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
