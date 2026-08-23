#!/bin/bash


set -e 

if pacman -Q megacmd &>/dev/null; then
    echo "MEGAcmd is already installed."
    exit 0
fi

curl -fsSL -o /tmp/megacmd.pkg.tar.zst \
    https://mega.nz/linux/repo/Arch_Extra/x86_64/megacmd-x86_64.pkg.tar.zst

sudo pacman -U --noconfirm /tmp/megacmd.pkg.tar.zst

rm -f /tmp/megacmd.pkg.tar.zst
