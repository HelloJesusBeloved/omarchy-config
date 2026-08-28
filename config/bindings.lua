-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")


--Custom
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
