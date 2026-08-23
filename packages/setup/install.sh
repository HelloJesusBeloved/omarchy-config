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
    if [[ ! -s "$REPO_ROOT/packages/lists/install.txt" ]]; then
        echo "No packages to install."
        return
    fi  

    sudo pacman -Syu --needed --noconfirm \
        - < "$REPO_ROOT/packages/lists/install.txt"
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

    rm -f /tmp/megacmd.pkg.tar.zst
}

install_all() {
    install_packages
    install_aur_packages
    install_mega
}


usage() {
    echo "Usage: $0 [OPTION]"
    echo
    echo "Options:"
    echo "  -p        Install packages from install.txt"
    echo "  -a        Install AUR packages from install-aur.txt"
    echo "  -m        Install MEGAcmd"
    echo "  --all     Install packages, AUR packages, and MEGAcmd"
    echo "  --help    Show this help message"
}


case "$1" in
    -p)
        install_packages
        ;;
    -a)
        install_aur_packages
        ;;
    -m)
        install_mega
        ;;
    --all)
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
