--Custom


--1. Remove Defaults
--A SUPER +
local SUPER_PLUS = {
  "L",
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
  "L",
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

--Set Super + L to Lock system
o.bind("SUPER + L", "Lock system", "omarchy system lock")

--Screen Capture
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy capture screenshot")
o.bind("SUPER + SHIFT + T", "Extract Text", "omarchy capture text")
o.bind("SUPER + SHIFT + ALT + S", "Capture Menu", "omarchy menu summon capture")

--B. Apps
--Set Super + Shift + M to cliamp
o.bind("SUPER + SHIFT + M", "Music TUI", "omarchy launch or focus tui cliamp")

--Set Super + Shift + S to Signal
o.bind("SUPER + SHIFT + A", "Signal", "omarchy launch signal")

--Set Super + D to Discord
o.bind("SUPER + SHIFT + D", "Discord", "omarchy launch discord community")


--End-Custom
