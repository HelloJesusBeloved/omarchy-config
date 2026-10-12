#!/bin/bash

set -e

REPO_ROOT_DEPTH=2

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

REPO_ROOT="$SCRIPT_DIR"

for ((i = 0; i < REPO_ROOT_DEPTH; i++))
do
    REPO_ROOT="$(dirname "$REPO_ROOT")"
done


# Read package names from a list file (skipping blank lines and comments).
list_packages() {
    local list_file="$1"
    local package

    while IFS= read -r package || [[ -n "$package" ]]; do
        [[ -z "$package" || "$package" == \#* ]] && continue
        echo "$package"
    done < "$list_file"
}

remove_packages() {
    local PACKAGE_LIST="$REPO_ROOT/packages/lists/remove.txt"

    if [[ ! -s "$PACKAGE_LIST" ]]; then
        return
    fi

    local PACKAGES_TO_REMOVE=()
    local package

    while IFS= read -r package || [[ -n "$package" ]]; do
        # Skip blank lines and comments.
        [[ -z "$package" || "$package" == \#* ]] && continue

        if omarchy-pkg-present "$package"; then
            PACKAGES_TO_REMOVE+=("$package")
        fi
    done < "$PACKAGE_LIST"

    if [[ ${#PACKAGES_TO_REMOVE[@]} -eq 0 ]]; then
        echo "No packages to remove"
        return
    fi

    echo "Packages to remove:"
    printf '  %s\n' "${PACKAGES_TO_REMOVE[@]}"
    echo

    # Omarchy's approved way to remove packages: also removes configs
    # and unneeded dependencies.
    omarchy pkg drop "${PACKAGES_TO_REMOVE[@]}"
}

remove_aur_packages() {
    local -a packages

    # AUR packages have no Omarchy equivalent, so they are still
    # removed with yay (shipped by Omarchy).
    mapfile -t packages < <(
        pacman -Qqm |
        grep -Fx -f "$REPO_ROOT/packages/lists/remove-aur.txt" || true
    )

    if [[ ${#packages[@]} -eq 0 ]]; then
        echo "No AUR packages to remove."
        return
    fi

    printf '%s\n' "${packages[@]}" |
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
