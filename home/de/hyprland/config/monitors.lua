------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output = "DP-1",
    mode = "2560x1440@180",
    position = "1920x0",
    scale = "auto",
    vrr = 0, -- enable VRR
    -- icc = "/home/btngana/Documents/27M2C5501.icm",
})

hl.monitor({
    output    = "DP-2",
    mode      = "1920x1080@144",
    position  = "0x220",
    scale     = "auto",
    transform = 0, -- 90 degree rotation
    vrr       = 0, -- enable VRR
})
