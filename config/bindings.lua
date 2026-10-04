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


--C. SUPER + ALT +
local SUPER_ALT = {
  "K",
}

for _, key in ipairs(SUPER_ALT) do
  hl.unbind("SUPER + ALT + " .. key)
end


--D. SUPER + SHIFT + ALT +
local SUPER_SHIFT_ALT = {
  "M",
}

for _, key in ipairs(SUPER_SHIFT_ALT) do
  hl.unbind("SUPER + SHIFT + ALT + " .. key)
end


--E. SUPER + CTRL +
local SUPER_CTRL = {
  "K",
  "C",
}

for _, key in ipairs(SUPER_CTRL) do
  hl.unbind("SUPER + CTRL + " .. key)
end


--F. Single Keys
--a. PRINT
hl.unbind("PRINT")
hl.unbind("ALT + PRINT")
hl.unbind("SUPER + PRINT")
hl.unbind("SUPER + CTRL + PRINT")

--b. Volume buttons
hl.unbind("XF86AudioRaiseVolume")
hl.unbind("XF86AudioLowerVolume")



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

--Volume max 150%
o.bind("XF86AudioRaiseVolume", "Volume Up", "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ && omarchy-osd -i volume-high -p \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')\"")
o.bind("XF86AudioLowerVolume", "Volume Down", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && omarchy-osd -i volume-high -p \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')\"")

--Resize active window
hl.bind("SUPER + ALT + H",
  hl.dsp.window.resize({ x = -20, y = 0, relative = true }),
  { repeating = true })

hl.bind("SUPER + ALT + L",
  hl.dsp.window.resize({ x = 20, y = 0, relative = true }),
  { repeating = true })

hl.bind("SUPER + ALT + K",
  hl.dsp.window.resize({ x = 0, y = -20, relative = true }),
  { repeating = true })

hl.bind("SUPER + ALT + J",
  hl.dsp.window.resize({ x = 0, y = 20, relative = true }),
  { repeating = true })

--Alt + HJKL = Arrow Keys
hl.bind("ALT + H", hl.dsp.send_shortcut({ mods = "", key = "left" }), { repeating = true })
hl.bind("ALT + J", hl.dsp.send_shortcut({ mods = "", key = "down" }), { repeating = true })
hl.bind("ALT + K", hl.dsp.send_shortcut({ mods = "", key = "up" }), { repeating = true })
hl.bind("ALT + L", hl.dsp.send_shortcut({ mods = "", key = "right" }), { repeating = true })


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
