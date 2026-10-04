#!/bin/bash

set -e


SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"


mkdir -p "$INSTALL_DIR"


FILES=("$SCRIPT_DIR"/*)

if [[ ! -e "${FILES[0]}" ]]; then
    echo
    echo "No files found in $SCRIPT_DIR to install"
    exit 0
fi


INSTALLED=()
UPDATED=()
ALREADY_INSTALLED=()


for file in "${FILES[@]}"
do
    if [[ ! -f "$file" || "$(basename "$file")" == "install.sh" ]]; then
        continue
    fi

    NAME="$(basename "$file")"
    TARGET="$INSTALL_DIR/$NAME"


    if [[ ! -f "$TARGET" ]]; then
        install -Dm755 "$file" "$TARGET"
        INSTALLED+=("$NAME")

    elif ! cmp -s "$file" "$TARGET"; then
        install -Dm755 "$file" "$TARGET"
        UPDATED+=("$NAME")

    else
        ALREADY_INSTALLED+=("$NAME")
    fi
done


if [[ ${#INSTALLED[@]} -eq 0 &&
      ${#UPDATED[@]} -eq 0 ]]; then

    echo
    echo "All bin files are already installed."
    exit 0
fi


if [[ ${#INSTALLED[@]} -gt 0 ]]; then
    echo
    echo "Bin files installed:"

    for file in "${INSTALLED[@]}"
    do
        echo "  $file"
    done
fi


if [[ ${#UPDATED[@]} -gt 0 ]]; then
    echo
    echo "Bin files updated:"

    for file in "${UPDATED[@]}"
    do
        echo "  $file"
    done
fi
