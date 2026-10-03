-- Monitor configuration with primary display and fallback

hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "auto",
    scale = 1.0,
})

-- Fallback rule for any connected display
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1.0,
})
