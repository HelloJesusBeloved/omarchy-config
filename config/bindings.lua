--Custom


--1. Remove Defaults
--A SUPER +
local SUPER = {
  "L",
  "J",
  "K",
  "TAB",
  "F",
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
  "F",
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


--F. ALT +
local ALT = {
  "TAB",
  "SHIFT + TAB",
}

for _, key in ipairs(ALT) do
  hl.unbind("ALT + " .. key)
end


--G. Single Keys
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

-- Use Monocle only while a browser was stacked with another tiled window.
-- Unlike native fullscreen, Monocle keeps both windows the same size while
-- Alt+Tab switches between them.
local browser_classes = {
  ["glide-glide"] = true,
  ["firefox"] = true,
  ["firefox-esr"] = true,
  ["firefoxdeveloperedition"] = true,
  ["org.mozilla.firefox"] = true,
  ["librewolf"] = true,
  ["zen"] = true,
  ["chromium"] = true,
  ["chromium-browser"] = true,
  ["google-chrome"] = true,
  ["brave-browser"] = true,
  ["vivaldi-stable"] = true,
  ["floorp"] = true,
}

local browser_stacks = {}
local lone_fullscreens = {}

local function is_browser(window)
  return browser_classes[(window.class or ""):lower()] == true
end

local function tiled_count(workspace_id)
  local count = 0
  for _, window in ipairs(hl.get_workspace_windows(workspace_id)) do
    if not window.floating then
      count = count + 1
    end
  end
  return count
end

local function tiled_browser(workspace_id)
  for _, window in ipairs(hl.get_workspace_windows(workspace_id)) do
    if not window.floating and is_browser(window) then
      return window
    end
  end
end

local function change_layout(workspace_id, layout)
  -- Use Hyprland's workspace rule directly: it works for the current
  -- workspace and does not modify Omarchy's saved workspace-mode state.
  hl.workspace_rule({ workspace = workspace_id, layout = layout })
  hl.exec_scheduled_prop_refresh_immediately()
end

local function report_stack_error(message)
  hl.notification.create({ text = "Browser stack: " .. tostring(message), timeout = 20000, icon = "error" })
end

local function workspace_window(workspace_id, address)
  for _, window in ipairs(hl.get_workspace_windows(workspace_id)) do
    if window.address == address then return window end
  end
end

local function set_tiled_client_mode(window, client)
  -- Keep Monocle in charge of window geometry, while telling the selected
  -- application whether it should enter fullscreen or maximized mode.
  hl.dispatch(hl.dsp.window.fullscreen_state({
    internal = 0, client = client, action = "set", window = window,
  }))
end

local function restore_other_fullscreen_windows(workspace_id, stack)
  for _, previous in ipairs(stack.fullscreen_windows or {}) do
    local window = workspace_window(workspace_id, previous.address)
    if window and (window.fullscreen or 0) == 0 then
      hl.dispatch(hl.dsp.window.fullscreen_state({
        internal = previous.internal, client = previous.client,
        action = "set", window = window,
      }))
    end
  end
end

local function restore_browser_stack(workspace_id, restore_previous)
  local stack = browser_stacks[workspace_id]
  if not stack then return end

  browser_stacks[workspace_id] = nil
  local workspace = hl.get_workspace(workspace_id)
  local resume_native = restore_previous and workspace and workspace.tiled_layout == "monocle"
  local native_windows = {}
  if resume_native then
    for _, previous in ipairs(stack.fullscreen_windows or {}) do
      native_windows[previous.address] = true
    end
  end
  for address in pairs(stack.client_modes or {}) do
    local window = workspace_window(workspace_id, address)
    if window and not native_windows[address] and window.fullscreen_client ~= 0 then
      set_tiled_client_mode(window, 0)
    end
  end
  -- Respect a layout change the user made while the stack was active.
  if workspace and workspace.tiled_layout == "monocle" and stack.layout ~= "monocle" then
    change_layout(workspace_id, stack.layout)
  end
  if resume_native then
    -- Restore internal fullscreen without toggling the surviving client's
    -- presentation mode off and back on.
    restore_other_fullscreen_windows(workspace_id, stack)
  end
end

local function show_callback_errors(callback)
  return function(...)
    local event_window = ...
    local workspace = event_window and event_window.workspace or hl.get_active_workspace()
    local id = workspace and tostring(workspace.id)
    local ok, err = xpcall(callback, debug.traceback, ...)
    if not ok then
      -- If the error interrupted entry into Monocle, restore any window we
      -- took out of native fullscreen before showing the failure.
      local stack = id and browser_stacks[id]
      if stack then
        browser_stacks[id] = nil
        for address in pairs(stack.client_modes or {}) do
          local window = workspace_window(id, address)
          if window then pcall(set_tiled_client_mode, window, 0) end
        end
        pcall(change_layout, id, stack.layout)
        pcall(restore_other_fullscreen_windows, id, stack)
      end
      report_stack_error(tostring(err):sub(1, 500))
    end
  end
end

local function cycle_window(forward)
  return function()
    local ws = hl.get_active_special_workspace() or hl.get_active_workspace()
    if ws and ws.tiled_layout == "monocle" then
      hl.dispatch(hl.dsp.layout(forward and "cyclenext" or "cycleprev"))
    else
      -- These are Omarchy's stock Alt+Tab actions, in the same order.
      if forward then
        hl.dispatch(hl.dsp.window.cycle_next())
      else
        hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
      end
      hl.dispatch(hl.dsp.window.bring_to_top())
    end
  end
end

o.bind("ALT + TAB", "Focus on next window", show_callback_errors(cycle_window(true)))
o.bind("ALT + SHIFT + TAB", "Focus on previous window", show_callback_errors(cycle_window(false)))

local function enter_browser_stack(id, ws, browser, selected, requested_client, lone, incoming)
  local previous_layout = ws.tiled_layout
  local previous_fullscreen = {}
  local native_now = {}
  local client_modes = {}
  local original = lone and workspace_window(id, lone.address)
  -- With on_focus_under_fullscreen=take_over, the newly focused window may
  -- inherit native fullscreen before window.open fires.
  local transferred = original and incoming and (original.fullscreen or 0) == 0
    and (incoming.fullscreen or 0) ~= 0
  for _, other in ipairs(hl.get_workspace_windows(id)) do
    if not other.floating and (other.fullscreen_client or 0) ~= 0 then
      client_modes[other.address] = other.fullscreen_client
    end
    if (other.fullscreen or 0) ~= 0 then
      native_now[#native_now + 1] = other.address
      if not (transferred and other.address == incoming.address) then
        previous_fullscreen[#previous_fullscreen + 1] = {
          address = other.address, internal = other.fullscreen,
          client = other.fullscreen_client or 0,
        }
      end
    end
  end
  if lone then
    client_modes[lone.address] = lone.client
    if transferred then
      client_modes[incoming.address] = nil
      previous_fullscreen[#previous_fullscreen + 1] = {
        address = lone.address, internal = lone.mode, client = lone.client,
      }
    end
  end
  if selected then
    client_modes[selected.address] = requested_client
  end

  browser_stacks[id] = {
    layout = previous_layout, browser = browser.address,
    fullscreen_windows = previous_fullscreen,
    client_modes = client_modes,
  }
  if previous_layout ~= "monocle" then
    change_layout(id, "monocle")
  end
  local current = hl.get_workspace(id)
  if not current or current.tiled_layout ~= "monocle" then
    browser_stacks[id] = nil
    if previous_layout ~= "monocle" then change_layout(id, previous_layout) end
    report_stack_error("Monocle did not activate on workspace " .. id)
    return
  end

  -- Demote native fullscreen without telling the client to exit fullscreen.
  -- Glide keeps its presentation mode throughout the layout switch.
  for _, address in ipairs(native_now) do
    local other = workspace_window(id, address)
    if other then set_tiled_client_mode(other, client_modes[address] or 0) end
  end
  for address, client in pairs(client_modes) do
    local other = workspace_window(id, address)
    if other and (other.fullscreen_client or 0) ~= client then
      set_tiled_client_mode(other, client)
    end
  end
  if selected then hl.dispatch(hl.dsp.focus({ window = selected })) end
end

local function fullscreen_or_stack(mode)
  return function()
    local window = hl.get_active_window()
    if not window then return end

    local ws = hl.get_active_workspace()
    if hl.get_active_special_workspace() or not ws or ws.id < 1 then
      hl.dispatch(hl.dsp.window.fullscreen({ mode = mode }))
      return
    end

    local id = tostring(ws.id)
    local stack = browser_stacks[id]
    if not window.floating and tiled_count(id) == 1 then
      -- The other window may have closed before the delayed cleanup ran.
      -- Leave Monocle now, then use native fullscreen for the lone window.
      if stack then
        restore_browser_stack(id)
        window = workspace_window(id, window.address) or window
      end
      local requested = mode == "fullscreen" and 2 or 1
      local was_requested = window.fullscreen == requested
      -- Match Omarchy's native bind for a lone window, including its border
      -- and gap handling. Keep only the window identity for the open event.
      hl.dispatch(hl.dsp.window.fullscreen({ mode = mode }))
      lone_fullscreens[id] = was_requested and nil or {
        address = window.address, mode = requested, client = requested,
      }
      return
    end
    if stack then
      if window.floating then
        hl.dispatch(hl.dsp.window.fullscreen({ mode = mode, window = window }))
        return
      end
      -- Any tiled window in this browser workspace can request its own
      -- fullscreen client mode without changing the Monocle layout.
      local requested = mode == "fullscreen" and 2 or 1
      local client = window.fullscreen_client == requested and 0 or requested
      set_tiled_client_mode(window, client)
      if client == 0 then
        stack.client_modes[window.address] = nil
      else
        stack.client_modes[window.address] = client
      end
      if not next(stack.client_modes) then
        restore_browser_stack(id)
      end
      return
    end

    local browser = tiled_browser(id)
    if browser and not window.floating and tiled_count(id) >= 2 then
      lone_fullscreens[id] = nil
      enter_browser_stack(id, ws, browser, window, mode == "fullscreen" and 2 or 1)
    else
      hl.dispatch(hl.dsp.window.fullscreen({ mode = mode }))
    end
  end
end

-- Hyprland's take_over policy can transfer native fullscreen to the new
-- window before this event. The recorded keypress identifies its owner.
local function stack_on_window_open(window)
  local ws = window and window.workspace
  if not ws or ws.id < 1 then return end
  local id = tostring(ws.id)
  if window.floating then return end
  local lone = lone_fullscreens[id]
  if not lone or lone.address == window.address then return end

  local original = workspace_window(id, lone.address)
  if not original or original.floating then
    lone_fullscreens[id] = nil
    return
  end
  local browser = tiled_browser(id)
  if not browser or tiled_count(id) < 2 or browser_stacks[id] then return end

  lone_fullscreens[id] = nil
  enter_browser_stack(id, ws, browser, nil, nil, lone, window)
end

hl.on("window.open", show_callback_errors(stack_on_window_open))

local function clean_browser_stacks()
  local restore = {}
  for id, stack in pairs(browser_stacks) do
    local browser_present = false
    for _, window in ipairs(hl.get_workspace_windows(id)) do
      if window.address == stack.browser then browser_present = true end
    end
    if not browser_present or tiled_count(id) < 2 then
      restore[#restore + 1] = id
    end
  end
  for _, id in ipairs(restore) do
    restore_browser_stack(id, true)
  end
end

hl.on("window.destroy", function()
  hl.timer(clean_browser_stacks, { type = "oneshot", timeout = 1 })
end)
hl.on("window.move_to_workspace", function()
  hl.timer(clean_browser_stacks, { type = "oneshot", timeout = 1 })
end)

o.bind("SUPER + F", "Full screen or stack browser", show_callback_errors(fullscreen_or_stack("fullscreen")))
o.bind("SUPER + ALT + F", "Full width or stack browser", show_callback_errors(fullscreen_or_stack("maximized")))


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
