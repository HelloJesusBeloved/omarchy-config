#!/bin/bash

set -e

REPO_ROOT_DEPTH=2

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

REPO_ROOT="$SCRIPT_DIR"

for ((i = 0; i < REPO_ROOT_DEPTH; i++))
do
    REPO_ROOT="$(dirname "$REPO_ROOT")"
done


remove_packages() {
    local packages

    packages=$(
        pacman -Qq |
        grep -Fx -f "$REPO_ROOT/packages/lists/remove.txt" || true
    )

    if [[ -z "$packages" ]]; then
        echo "No packages to remove."
        return
    fi

    printf '%s\n' "$packages" |
        sudo pacman -Rns --noconfirm -
}

remove_aur_packages() {
    local packages

    packages=$(
        pacman -Qqm |
        grep -Fx -f "$REPO_ROOT/packages/lists/remove-aur.txt" || true
    )

    if [[ -z "$packages" ]]; then
        echo "No AUR packages to remove."
        return
    fi

    printf '%s\n' "$packages" |
        yay -Rns --noconfirm -
}

remove_web_apps() {
    local app
    local found=0

    while IFS= read -r app
    do
        [[ -z "$app" ]] && continue

        if [[ -f "$HOME/.local/share/applications/$app.desktop" ]]; then
            found=1
            omarchy-webapp-remove "$app"
        fi
    done < "$REPO_ROOT/packages/lists/remove-web-app.txt"

    if [[ $found -eq 0 ]]; then
        echo "No web apps to remove."
    fi
}

remove_all() {
    remove_packages
    remove_aur_packages
    remove_web_apps
}

usage() {
    echo "Usage: $0 [OPTION]"
    echo
    echo "Options:"
    echo "  -p        Remove packages from remove.txt"
    echo "  -a        Remove AUR packages from remove-aur.txt"
    echo "  --help    Show this help message"
    echo "  no flag   Remove all"
}


case "$1" in
    -p)
        remove_packages
        ;;
    -a)
        remove_aur_packages
        ;;
    "")
        remove_all
        ;;
    --help)
        usage
        ;;
    *)
        echo "Error: Unknown option '$1'"
        echo
        usage
        exit 1
        ;;
esac
