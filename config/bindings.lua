--Custom


--1. Remove Defaults
--A SUPER +
local SUPER = {
  "L",
  "J",
  "K",
  "TAB",
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
  "LEFT",
  "RIGHT",
  "UP",
  "DOWN",
}

for _, key in ipairs(SUPER_SHIFT) do
  hl.unbind("SUPER + SHIFT + " .. key)
end


--C. SUPER + ALT +
local SUPER_ALT = {
  "K",
  "V",
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

o.bind("SUPER + SHIFT + H", "Swap window left", function() hl.dispatch(hl.dsp.window.swap({ direction = "left" })) end)
o.bind("SUPER + SHIFT + J", "Swap window down", function() hl.dispatch(hl.dsp.window.swap({ direction = "down" })) end)
o.bind("SUPER + SHIFT + K", "Swap window up", function() hl.dispatch(hl.dsp.window.swap({ direction = "up" })) end)
o.bind("SUPER + SHIFT + L", "Swap window right", function() hl.dispatch(hl.dsp.window.swap({ direction = "right" })) end)

--Show Keybindings
o.bind("SUPER + CTRL + K", "Show Keybindings", "omarchy menu keybindings")

--Toggle Window Split
o.bind("SUPER + I", "Toggle window split", hl.dsp.layout("togglesplit"))

--Volume max 150%
o.bind("XF86AudioRaiseVolume", "Volume Up", "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ && omarchy-osd -i volume-high -p \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')\"", { repeating = true })
o.bind("XF86AudioLowerVolume", "Volume Down", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && omarchy-osd -i volume-high -p \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')\"", { repeating = true })

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

--Paste 2nd to last clipboard item
o.bind("SUPER + ALT + V", "Paste Previous Clipboard", [[ "$HOME/.local/bin/omarchy-paste-previous" ]], { release = true })

--Toggle Screensaver
o.bind("SUPER + CTRL + U", "Toggle Screensaver", "omarchy toggle screensaver")

-- Super+Tab: cycle through recently used workspaces.
local workspace_history = {}
local workspace_cycle = nil

local function active_id()
  local ws = hl.get_active_workspace()
  return ws and not ws.special and ws.id and ws.id > 0 and ws.id or nil
end

local function remember(id)
  if not id or workspace_history[1] == id then return end

  for i = #workspace_history, 1, -1 do
    if workspace_history[i] == id then
      table.remove(workspace_history, i)
    end
  end
  table.insert(workspace_history, 1, id)
end

hl.on("workspace.active", function(ws)
  if workspace_cycle or not ws or ws.special or not ws.id then return end

  local monitor = hl.get_active_monitor()
  if monitor and ws.monitor and ws.monitor.name == monitor.name then
    remember(ws.id)
  end
end)

hl.on("monitor.focused", function()
  if not workspace_cycle then remember(active_id()) end
end)

-- Commit the selected workspace when either Super key is released.
hl.on("input.keyboard.key", function(keycode, _, state)
  if state == 0 and (keycode == 133 or keycode == 134) and workspace_cycle then
    workspace_cycle = nil
    remember(active_id())
  end
end)

o.bind("SUPER + TAB", "Cycle recent workspaces", function()
  local current = active_id()
  if not current then return end

  if not workspace_cycle then
    remember(current)

    local order = {}
    for i, id in ipairs(workspace_history) do
      order[i] = id
    end
    workspace_cycle = { order = order, position = 1 }
  end

  local order = workspace_cycle.order

  -- On first use, ask Hyprland for the previous workspace.
  if #order == 1 then
    hl.dispatch(hl.dsp.focus({ workspace = "previous" }))
    local selected = active_id()

    if selected and selected ~= current then
      order[2] = selected
      workspace_cycle.position = 2
    else
      workspace_cycle = nil
    end
    return
  end

  local next_position = workspace_cycle.position % #order + 1
  local target = order[next_position]

  hl.dispatch(hl.dsp.focus({ workspace = tostring(target) }))
  if active_id() == target then
    workspace_cycle.position = next_position
  end
end)


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
