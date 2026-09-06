--Custom


--1. Remove Defaults
--A SUPER +
local SUPER_PLUS = {
  "L",
  "J",
  "K",
}

for _, key in ipairs(SUPER_PLUS) do
  hl.unbind("SUPER + " .. key)
end

--B. SUPER + SHIFT +
local SUPER_SHIFT_PLUS = {
  "M",
  "N",
  "A",
  "S",
  "G",
  "D",
  "B",
}

for _, key in ipairs(SUPER_SHIFT_PLUS ) do
  hl.unbind("SUPER + SHIFT + " .. key)
end

--C. SUPER + SHIFT + ALT +
local SUPER_SHIFT_ALT_PLUS = {
  "M",
}

for _, key in ipairs(SUPER_SHIFT_ALT_PLUS) do
  hl.unbind("SUPER + SHIFT + ALT + " .. key)
end

--D. SUPER + CTRL +
local SUPER_CTRL_PLUS = {
  "K",
}

for _, key in ipairs(SUPER_CTRL_PLUS) do
  hl.unbind("SUPER + CTRL + " .. key)
end

--E. Single Keys
--a. PRINT
hl.unbind("PRINT")
hl.unbind("ALT + PRINT")
hl.unbind("SUPER + PRINT")
hl.unbind("SUPER + CTRL + PRINT")


--2. Add Mine
--A. System

--Screen Capture
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy capture screenshot")
o.bind("SUPER + SHIFT + T", "Extract Text", "omarchy capture text")
o.bind("SUPER + SHIFT + ALT + S", "Capture Menu", "omarchy menu summon capture")

--Vim Window Navigation
o.bind("SUPER + J", "Focus window down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus window down", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus window down", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + H", "Focus window down", hl.dsp.focus({ direction = "r" }))

--Keybindings
o.bind("SUPER + CTRL + K", "Show Keybindings", "omarchy menu keybindings")

--Toggle Window Split
o.bind("SUPER + I", "Toggle window split", hl.dsp.layout("togglesplit"))


--B. Apps
--Set Super + Shift + M to cliamp
o.bind("SUPER + SHIFT + M", "Music TUI", "omarchy launch or focus tui cliamp")

--Set Super + Shift + S to Signal
o.bind("SUPER + SHIFT + A", "Signal", "omarchy launch signal")

--Set Super + D to Discord
o.bind("SUPER + SHIFT + D", "Discord", "omarchy launch discord community")

--Set Super + Shift + B to BlueBubbles
o.bind("SUPER + SHIFT + B", "BlueBubbles", "bluebubbles")

--Set Super + Shift + V to mpv gui, and Super + Shift + Alt + V to open the clipboard in player
o.bind("SUPER + SHIFT + V", "mpv", "mpv --player-operation-mode=pseudo-gui --fs")
o.bind("SUPER + SHIFT + ALT + V", "mpv", "mpv --player-operation-mode=pseudo-gui --fs \"$(wl-paste --no-newline)\"")

--End-Custom
