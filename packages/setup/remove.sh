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
    sudo pacman -Rns --noconfirm \
        - < "$REPO_ROOT/packages/lists/remove.txt"
}


remove_aur_packages() {
    yay -Rns --noconfirm \
        - < "$REPO_ROOT/packages/lists/remove-aur.txt"
}


usage() {
    echo "Usage: $0 [OPTION]"
    echo
    echo "Options:"
    echo "  -p        Remove packages from remove.txt"
    echo "  -a        Remove AUR packages from remove-aur.txt"
    echo "  --help    Show this help message"
}


case "$1" in
    -p)
        remove_packages
        ;;
    -a)
        remove_aur_packages
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
