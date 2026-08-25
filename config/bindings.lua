

--1. System

--Set Super + L to Lock system
hl.unbind("SUPER + L") --Used to be Toggle workspace layout (between scolling and dwindle)
hl.unbind("SUPER + CTRL + L") --Used to be Lock system)
o.bind("SUPER + L", "Lock system", "omarchy system lock")


--2. Apps

--Set Super + Shift + M to cliamp
hl.unbind("SUPER + SHIFT + M") --Used to be Spotify
hl.unbind("SUPER + SHIFT ALT + M") --Used to be cliamp
o.bind("SUPER + SHIFT + M", "Music TUI", "omarchy launch or focus tui cliamp")

--Set Super + Shift + S to Signal
hl.unbind("SUPER + SHIFT + S") --Used to be Google Maps
hl.unbind("SUPER + SHIFT + G") --Used to be Signal
o.bind("SUPER + SHIFT + S", "Signal", "omarchy launch signal")

--Set Super + D to Discord
hl.unbind("SUPER + SHIFT + D") --Used to be lazy docker
o.bind("SUPER + SHIFT + D", "Discord", "omarchy launch discord community")
