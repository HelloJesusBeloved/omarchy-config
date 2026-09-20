--Custom


--1. Remove Defaults
--A SUPER +
local SUPER = {
  "L",
  "J",
  "K",
}

for _, key in ipairs(SUPER) do
  hl.unbind("SUPER + " .. key)
end


--B. SUPER + SHIFT +
local SUPER_SHIFT = {
  "M",
  "N",
  "A",
  "S",
  "G",
  "D",
  "B",
  "C",
}

for _, key in ipairs(SUPER_SHIFT) do
  hl.unbind("SUPER + SHIFT + " .. key)
end


--C. SUPER + SHIFT + ALT +
local SUPER_SHIFT_ALT = {
  "M",
}

for _, key in ipairs(SUPER_SHIFT_ALT) do
  hl.unbind("SUPER + SHIFT + ALT + " .. key)
end


--D. SUPER + CTRL +
local SUPER_CTRL = {
  "K",
  "C",
}

for _, key in ipairs(SUPER_CTRL) do
  hl.unbind("SUPER + CTRL + " .. key)
end


--E. Single Keys
--a. PRINT
hl.unbind("PRINT")
hl.unbind("ALT + PRINT")
hl.unbind("SUPER + PRINT")
hl.unbind("SUPER + CTRL + PRINT")



--2. Add Mine
--Note: WC = open with clipboard contents passed
--A. System

--Screen Capture
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy capture screenshot")
o.bind("SUPER + SHIFT + T", "Extract Text", "omarchy capture text")
o.bind("SUPER + SHIFT + C", "Extract Color", "hyprpicker -a")
o.bind("SUPER + SHIFT + ALT + S", "Capture Menu", "omarchy menu summon capture")

--Vim Window Navigation
o.bind("SUPER + J", "Focus window down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus window down", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus window down", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + H", "Focus window down", hl.dsp.focus({ direction = "l" }))

--Show Keybindings
o.bind("SUPER + CTRL + K", "Show Keybindings", "omarchy menu keybindings")

--Toggle Window Split
o.bind("SUPER + I", "Toggle window split", hl.dsp.layout("togglesplit"))


--B. Apps
--cliamp = Super + Shift + M
o.bind("SUPER + SHIFT + M", "Music TUI", "omarchy launch or focus tui cliamp")

--Signal = Super + Shift + A
o.bind("SUPER + SHIFT + A", "Signal", "omarchy launch signal")

--Discord = Super + Shift + D
o.bind("SUPER + SHIFT + D", "Discord", "omarchy launch discord community")

--BlueBubbles = Super + Shift + B
o.bind("SUPER + SHIFT + B", "BlueBubbles", "bluebubbles")

--mpv gui fullscreen = Super + Shift + V
--mpv gui fullscreen WC = Super + Shift + Alt + V
o.bind("SUPER + SHIFT + V", "mpv", "mpv --player-operation-mode=pseudo-gui --fs")
o.bind("SUPER + SHIFT + ALT + V", "mpv", "mpv --player-operation-mode=pseudo-gui --fs \"$(wl-paste --no-newline)\"")

--Brave = Super + Shift + Alt + Enter
--Brave WC = Super + Shift + Control + Alt + Enter
o.bind("SUPER + SHIFT + ALT + Return", "Brave", "brave")
o.bind("SUPER + SHIFT + CTRL + ALT + Return", "Brave", "brave \"$(wl-paste --no-newline)\"")


--Remmina = Super + Shift + R
o.bind("SUPER + SHIFT + R", "Remmina", "remmina")


--End-Custom
