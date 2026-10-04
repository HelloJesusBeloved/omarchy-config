#!/bin/bash

set -e


REPO_ROOT_DEPTH=0

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

REPO_ROOT="$SCRIPT_DIR"

for ((i = 0; i < REPO_ROOT_DEPTH; i++))
do
    REPO_ROOT="$(dirname "$REPO_ROOT")"
done


INSTALL_SCRIPTS=(
    "$REPO_ROOT/packages/setup/remove.sh"
    "$REPO_ROOT/packages/setup/install.sh"
    "$REPO_ROOT/config/install.sh"
    "$REPO_ROOT/services/install.sh"
    "$REPO_ROOT/bin/install.sh"
)


#Make scripts executable and run them
for script in "${INSTALL_SCRIPTS[@]}"
do
    chmod +x "$script"
    "$script"
done

