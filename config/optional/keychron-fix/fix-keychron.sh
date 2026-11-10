#!/usr/bin/env bash
set -euo pipefail

RULE_FILE="/etc/udev/rules.d/70-keychron.rules"
RULE='SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", TAG+="uaccess"'

echo "Installing Keychron HID permissions fix..."

# Automatically elevate privileges if necessary.
if [[ "$EUID" -ne 0 ]]; then
    echo "Requesting administrator privileges..."
    exec sudo bash "$0" "$@"
fi

# Create the udev rules directory if necessary.
mkdir -p /etc/udev/rules.d

# Install the rule only if it is not already present.
if [[ ! -f "$RULE_FILE" ]] || ! grep -Fxq "$RULE" "$RULE_FILE"; then
    printf '%s\n' "$RULE" > "$RULE_FILE"
    echo "Installed Keychron udev rule."
else
    echo "Keychron udev rule already exists. Skipping."
fi

# Reload udev rules.
udevadm control --reload-rules

# Apply rules to currently connected HID devices.
udevadm trigger --subsystem-match=hidraw

echo ""
echo "Keychron Linux permissions fix applied successfully!"
echo "Reconnect your keyboard if access is not immediately available."
