#!/bin/bash
set -e

# Get the directory this script is located in, regardless of where it is run from.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

SERVICE_DIR="$SCRIPT_DIR"
INSTALL_DIR="$HOME/.config/systemd/user"

mkdir -p "$INSTALL_DIR"

#Put a space above whatever is output so it is nicely separated when you run REPO_ROOT/install.sh
echo

SERVICES=("$SERVICE_DIR"/*.service)

# Make sure there are actually .service files to install.
if [[ ! -e "${SERVICES[0]}" ]]; then
    echo "Error: No .service files found in $SERVICE_DIR"
    exit 0
fi

INSTALLED=()
UPDATED=()
ALREADY_INSTALLED=()
FAILED=()

# Install or update services.
for service in "${SERVICES[@]}"
do
    SERVICE_NAME="$(basename "$service")"
    TARGET="$INSTALL_DIR/$SERVICE_NAME"

    if [[ ! -f "$TARGET" ]]; then
        if cp "$service" "$TARGET"; then
            INSTALLED+=("$SERVICE_NAME")
        else
            echo "Error: Could not install $SERVICE_NAME."
            FAILED+=("$SERVICE_NAME")
        fi

    elif ! diff -q "$service" "$TARGET" &>/dev/null; then
        if cp "$service" "$TARGET"; then
            UPDATED+=("$SERVICE_NAME")
        else
            echo "Error: Could not update $SERVICE_NAME."
            FAILED+=("$SERVICE_NAME")
        fi

    else
        ALREADY_INSTALLED+=("$SERVICE_NAME")
    fi
done

# Reload systemd once after all service files have been copied/updated.
if ! systemctl --user daemon-reload; then
    echo "Error: Could not reload the user systemd manager."
    exit 1
fi

# Enable and start newly installed or updated services.
for SERVICE_NAME in "${INSTALLED[@]}" "${UPDATED[@]}"
do
    if ! systemctl --user enable --now "$SERVICE_NAME"; then
        echo "Error: $SERVICE_NAME could not be enabled/started."
        FAILED+=("$SERVICE_NAME")
    fi
done

# If everything was already installed and up to date, say so.
if [[ ${#INSTALLED[@]} -eq 0 && ${#UPDATED[@]} -eq 0 && ${#FAILED[@]} -eq 0 ]]; then
    echo "All services are already installed."
    exit 0
fi

# Show newly installed services.
if [[ ${#INSTALLED[@]} -gt 0 ]]; then
    echo "Services installed and enabled:"
    for service in "${INSTALLED[@]}"
    do
        echo "  $service"
    done
fi

# Show updated services.
if [[ ${#UPDATED[@]} -gt 0 ]]; then
    echo "Services updated and enabled:"
    for service in "${UPDATED[@]}"
    do
        echo "  $service"
    done
fi

# Show failures and return an error.
if [[ ${#FAILED[@]} -gt 0 ]]; then
    echo
    echo "The following services could not be installed/enabled:"
    for service in "${FAILED[@]}"
    do
        echo "  $service"
    done
    exit 1
fi
