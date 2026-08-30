#!/bin/bash


set -e


REPO_ROOT_DEPTH=2

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

REPO_ROOT="$SCRIPT_DIR"

for ((i = 0; i < REPO_ROOT_DEPTH; i++))
do
    REPO_ROOT="$(dirname "$REPO_ROOT")"
done


install_packages() {
    local PACKAGE_LIST="$REPO_ROOT/packages/lists/install.txt"

    if [[ ! -s "$PACKAGE_LIST" ]]; then
        echo "No packages to install, REPO_ROOT/packages/lists/install.txt is empty."
        return
    fi

    local PACKAGES_TO_INSTALL=()

    while IFS= read -r package || [[ -n "$package" ]]; do
        # Skip blank lines and comments.
        [[ -z "$package" || "$package" == \#* ]] && continue

        if ! pacman -Q "$package" &>/dev/null; then
            PACKAGES_TO_INSTALL+=("$package")
        fi
    done < "$PACKAGE_LIST"

    if [[ ${#PACKAGES_TO_INSTALL[@]} -eq 0 ]]; then
        echo "No packages to install, all packages are already installed."
        return
    fi

    echo "Packages to install:"
    printf '  %s\n' "${PACKAGES_TO_INSTALL[@]}"
    echo

    sudo pacman -S --needed --noconfirm "${PACKAGES_TO_INSTALL[@]}"
}

install_aur_packages() {
    yay -S --needed --noconfirm \
        - < "$REPO_ROOT/packages/lists/install-aur.txt"
}


install_mega() {
    if pacman -Q megacmd &>/dev/null; then
        echo "MEGAcmd is already installed."
        return
    fi

    curl -fsSL -o /tmp/megacmd.pkg.tar.zst \
        https://mega.nz/linux/repo/Arch_Extra/x86_64/megacmd-x86_64.pkg.tar.zst

    sudo pacman -U --noconfirm /tmp/megacmd.pkg.tar.zst
    sudo pacman -Sy

    rm -f /tmp/megacmd.pkg.tar.zst
}

install_tailscale() {
    if command -v tailscale &>/dev/null; then
        echo "Tailscale is already installed."
        return
    fi

    omarchy install service tailscale
}


install_signal() {
    if command -v signal-desktop &>/dev/null; then
        echo "Signal is already installed."
        return
    fi

    omarchy install service signal
}

install_other() {
    install_mega
    install_tailscale
    install_signal
}

install_all() {
    install_packages
    install_aur_packages
    install_other
    }


usage() {
    echo "Usage: $0 [OPTION]"
    echo
    echo "Options:"
    echo "  -p        Install packages from install.txt"
    echo "  -a        Install AUR packages from install-aur.txt"
    echo "  -o        Install MEGAcmd, Signal, and Tailscale"
    echo "  --help    Show this help message"
    echo "  no flag   Install packages, AUR packages, and MEGAcmd"
}


case "$1" in
    -p)
        install_packages
        ;;
    -a)
        install_aur_packages
        ;;
    -o)
        install_other
        ;;
    "")
        install_all
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
