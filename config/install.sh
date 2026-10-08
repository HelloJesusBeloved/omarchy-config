#!/bin/bash


set -e 


REPO_ROOT_DEPTH=1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

REPO_ROOT="$SCRIPT_DIR"

for ((i = 0; i < REPO_ROOT_DEPTH; i++))
do
    REPO_ROOT="$(dirname "$REPO_ROOT")"
done


#NOTE: This is only what I am able to configure simply via bash script, does not neccessrily include all the config from the README.md.
#
#Currently configures: 


#1. Aliases
ALIASES=(
    ""
    ""
    ""
    "alias vim='nvim'"
    ""

    "alias mega='mega-cmd'"
    "alias megas='mega-sync'"
    ""

    "alias cm='cmatrix'"
    "alias fsf='fastfetch'"
    "alias om='omarchy launch screensaver'"
    ""
    ""
)

#Add Aliases
for alias in "${ALIASES[@]}"
do
    if [[ -z "$alias" ]]; then
        echo >> "$HOME/.bashrc"
        continue
    fi

    if ! grep -Fxq "$alias" "$HOME/.bashrc"
    then
        echo "$alias" >> "$HOME/.bashrc"
        echo "added $alias to .bashrc"
    fi
done

# 1. Unalias Omarchy defaults
UNALIASES=(
    "zd"
    ""

    "a"
    "c"
    "cx"
    "cy"
    "d"
    "r"
    "h"
    "ic"
    "ix"
    "icx"
    "mup"
    ""

    "g"
    "gcm"
    "gcam"
    "gcad"
    ""
    ""
)

# Add Unaliases
for unalias in "${UNALIASES[@]}"
do
    if [[ -z "$unalias" ]]; then
        echo >> "$HOME/.bashrc"
        continue
    fi

    UNALIAS_LINE="unalias $unalias 2>/dev/null"

    if ! grep -Fxq "$UNALIAS_LINE" "$HOME/.bashrc"
    then
        echo "$UNALIAS_LINE" >> "$HOME/.bashrc"
        echo "added $UNALIAS_LINE to .bashrc"
    fi
done

echo
echo "To have aliases in the current shell:"
echo "source $HOME/.bashrc"


#2. Glide.ts
GLIDE_REPO_LOCATION="$HOME/Code/Projects/Prod"
GLIDE_REPO="$GLIDE_REPO_LOCATION/glide-config"

REPO_GLIDE_TS="$GLIDE_REPO/glide.ts"
LOCAL_GLIDE_TS="$HOME/.config/glide/glide.ts"

mkdir -p "$GLIDE_REPO_LOCATION"

echo

if [[ ! -d "$GLIDE_REPO/.git" ]]; then

    echo "Glide config repo not found. Cloning..."

    if git clone "https://git.nerdvpn.de/HelloJesusBeloved/glide-config" "$GLIDE_REPO"; then
        echo "Glide config repo cloned successfully."
    else
        echo "Failed to clone Glide config repo."
        exit 1
    fi

else

    GLIDE_BRANCH="$(git -C "$GLIDE_REPO" branch --show-current)"

    if [[ -z "$GLIDE_BRANCH" ]]; then
        echo "Failed to determine current Glide config branch."
        exit 1
    fi

    LOCAL_COMMIT="$(git -C "$GLIDE_REPO" rev-parse HEAD)"

    echo "Checking Glide config remote..."

    if ! git -C "$GLIDE_REPO" fetch origin "$GLIDE_BRANCH"; then
        echo "Failed to check Glide config remote."
        exit 1
    fi

    REMOTE_COMMIT="$(
        git -C "$GLIDE_REPO" rev-parse "origin/$GLIDE_BRANCH"
    )"

    if [[ "$LOCAL_COMMIT" == "$REMOTE_COMMIT" ]]; then
        echo "Glide config repo is already up to date."
    else
        echo "Glide config repo has changes. Updating..."

        if git -C "$GLIDE_REPO" merge --ff-only "origin/$GLIDE_BRANCH"; then
            echo "Glide config repo updated successfully."
        else
            echo "Failed to update Glide config repo."
            echo "Local branch has diverged from origin/$GLIDE_BRANCH."
            exit 1
        fi
    fi

fi

if ! cmp -s "$LOCAL_GLIDE_TS" "$REPO_GLIDE_TS"; then
    if cp "$REPO_GLIDE_TS" "$LOCAL_GLIDE_TS"; then
        echo "Glide Configuration File Updated Successfully"
        echo
    else
        echo "Failed to Update (cp) Glide Configuration File"
        echo "Please make sure that you have initialized your glide config from inside Glide Browser"
        echo
    fi
else
    echo "Glide Configuration File is already up to date"
    echo
fi

#3 XCompose
XCOMPOSE_REPO_LOCATION="$REPO_ROOT/config/XCompose"
XCOMPOSE_LOCAL_LOCATION="$HOME/.XCompose"

if cp $XCOMPOSE_REPO_LOCATION $XCOMPOSE_LOCAL_LOCATION
then
    echo "XCompose successfully installed to $XCOMPOSE_LOCAL_LOCATION"
    echo
    omarchy-restart-xcompose
else
    echo "XCompose failed to install (cp)"
    echo
fi


# 4. Hyprland configuration installation
HYPRLAND_CONFIGS=(
    "$REPO_ROOT/config/bindings.lua;$HOME/.config/hypr/bindings.lua"
    "$REPO_ROOT/config/input.lua;$HOME/.config/hypr/input.lua"
    "$REPO_ROOT/config/looknfeel.lua;$HOME/.config/hypr/looknfeel.lua"
)

# Print 0 or 1 for the number of complete custom sections.
# Reject missing partners, reversed markers, or multiple sections.
hypr_custom_count() {
    awk '
        $0 == "--Custom" {
            if (start || finish) invalid = 1
            start = NR
        }
        $0 == "--End-Custom" {
            if (!start || finish) invalid = 1
            finish = NR
        }
        END {
            if (invalid || ((start > 0) != (finish > 0))) exit 1
            print (start > 0 ? 1 : 0)
        }
    ' "$1"
}

# Check every pair before this section starts installing files.
for config_pair in "${HYPRLAND_CONFIGS[@]}"; do
    repo_file="${config_pair%%;*}"
    local_file="${config_pair#*;}"

    if [[ ! -f "$repo_file" || ! -r "$repo_file" ]]; then
        echo "ERROR: Repository file missing or unreadable: $repo_file" >&2
        exit 1
    fi

    if [[ ! -f "$local_file" || ! -r "$local_file" || ! -w "$local_file" ]]; then
        echo "ERROR: Local file missing, unreadable, or unwritable: $local_file" >&2
        echo "Allow Omarchy to generate it before installing custom configuration." >&2
        exit 1
    fi

    if ! repo_count=$(hypr_custom_count "$repo_file") ||
       [[ "$repo_count" != 1 ]]; then
        echo "ERROR: Expected one --Custom / --End-Custom section in $repo_file" >&2
        exit 1
    fi

    if ! hypr_custom_count "$local_file" >/dev/null; then
        echo "ERROR: Incomplete, reversed, or duplicate custom markers in $local_file" >&2
        exit 1
    fi
done

for config_pair in "${HYPRLAND_CONFIGS[@]}"; do
    repo_file="${config_pair%%;*}"
    local_file="${config_pair#*;}"
    config_name="${local_file##*/}"

    repo_custom=$(sed -n '/^--Custom$/,/^--End-Custom$/p' "$repo_file") || exit 1
    local_custom=$(sed -n '/^--Custom$/,/^--End-Custom$/p' "$local_file") || exit 1

    if [[ "$local_custom" == "$repo_custom" ]]; then
        echo "$config_name: custom configuration is already up to date."
        continue
    fi

    hypr_temp_file=$(mktemp) || exit 1

    if ! {
        if [[ -z "$local_custom" ]]; then
            # No custom section: keep the file and append the new section.
            cat -- "$local_file" &&
            printf '\n\n%s\n' "$repo_custom"
        else
            # Replace only the marked section, keeping content on both sides.
            sed '/^--Custom$/,$d' "$local_file" &&
            printf '%s\n' "$repo_custom" &&
            sed '1,/^--End-Custom$/d' "$local_file"
        fi
    } > "$hypr_temp_file"; then
        rm -f -- "$hypr_temp_file"
        echo "ERROR: Failed to prepare $config_name." >&2
        exit 1
    fi

    if cp -- "$hypr_temp_file" "$local_file"; then
        echo "$config_name: custom configuration successfully installed."
    else
        rm -f -- "$hypr_temp_file"
        echo "ERROR: Failed to update $config_name." >&2
        exit 1
    fi

    rm -f -- "$hypr_temp_file"
done

#5. Plugins to add/enable
PLUGINS_TO_ENABLE=(
)

for plugin in "${PLUGINS_TO_ENABLE[@]}"
do
    omarchy plugin enable $plugin
done


#6. Directorys to make
DIRECTORYS_TO_MAKE=(
"$HOME/Videos/YouTube/YouTube-dl/"
"$HOME/Code/Projects/"
"$HOME/Pictures/"{Wallpapers,Screenshots}
"$HOME/Downloads/"{Applications/{Apps,Bootable},Backups}
)

for dir in "${DIRECTORYS_TO_MAKE[@]}"
do
  if [[ ! -d "$dir" ]]; then

    if mkdir -p $dir
    then
      echo "Directory $dir successfully installed"
    else
      echo "Directory $dir could not be installed"
    fi

  fi
done


#7. Mega Syncs to add
MEGA_SYNCS_TO_ADD=(
    "$HOME/Videos/YouTube/YouTube-dl/;/Videos/YouTube/YouTube-dl"
)

if ! command -v mega-cmd &>/dev/null; then
    echo
    echo "mega-cmd is not installed. Please install it before configuring MEGA Sync."
else
    if mega-whoami 2>&1 | grep -Fq "Not logged in."; then
        echo
        echo "MEGA account is not logged in. Please run 'mega-login' first."
    else
        for sync in "${MEGA_SYNCS_TO_ADD[@]}"
        do
            LOCAL_PATH="${sync%%;*}"
            REMOTE_PATH="${sync#*;}"

            if mega-sync "$LOCAL_PATH" &>/dev/null; then
                echo
                echo "MEGA Sync already configured: $LOCAL_PATH -> $REMOTE_PATH"
            else
                echo
                echo "MEGA Sync not configured: $LOCAL_PATH -> $REMOTE_PATH"

                if mega-sync "$LOCAL_PATH" "$REMOTE_PATH"; then
                    echo "MEGA Sync successfully added: $LOCAL_PATH -> $REMOTE_PATH"
                else
                    echo "MEGA Sync could not be added: $LOCAL_PATH -> $REMOTE_PATH"
                fi
            fi
        done
    fi
fi
