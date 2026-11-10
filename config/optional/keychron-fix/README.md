# Keychron C3 Pro 8K — Linux Fix (Omarchy)

## Problem

Keychron Launcher and VIA could detect the keyboard but failed to initialize it on Omarchy Linux.

The issue was caused by Linux device permissions. The keyboard's `/dev/hidraw` device files were owned by `root` with `600` permissions, preventing my regular user from accessing the HID interfaces.

## Temporary fix

Granted my user read/write access to the three Keychron HID interfaces:

```bash
for n in 5 6 7; do
    sudo setfacl -m "u:$(id -un):rw" "/dev/hidraw$n"
done
```

This immediately fixed Keychron Launcher, confirming that the issue was related to Linux permissions rather than firmware.

However, these permissions were reset whenever the keyboard was unplugged or reconnected.

## Permanent fix

Created `/etc/udev/rules.d/70-keychron.rules` with the following rule:

```udev
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", TAG+="uaccess"
```

This instructs systemd-logind to grant the active local user access to the Keychron HID devices.

Reloaded the udev rules:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=hidraw
```

After reconnecting the keyboard, Keychron Launcher worked without manually changing device permissions.

## Automated installation script

The following Bash script automates the permanent fix.

Features:
- Automatically requests sudo privileges when needed.
- Reuses cached sudo credentials when available.
- Installs the udev rule.
- Avoids unnecessary modifications if the rule already exists.
- Reloads udev rules and triggers the HID subsystem.
- Is idempotent: running it multiple times is safe.

### `fix-keychron.sh`

## Run the script

Make it executable:

```bash
chmod +x fix-keychron.sh
```

Run it:

```bash
./fix-keychron.sh
```

No need to manually run `sudo`. The script automatically elevates itself when necessary and reuses cached sudo credentials if available.

You can safely execute it multiple times. It won't duplicate the udev rule.

## Result

- Keychron Launcher can initialize the keyboard.
- No manual `setfacl` commands are required.
- Permissions are managed automatically through udev.
- The fix survives unplugging and reconnecting the keyboard.
- No firmware flashing or keyboard configuration changes are required.

**Note:** The script assumes `/etc/udev/rules.d/70-keychron.rules` is dedicated to this fix. If that file already contains unrelated rules, preserve them when installing the new rule. `TAG+="uaccess"` relies on systemd-logind and an active local session.
