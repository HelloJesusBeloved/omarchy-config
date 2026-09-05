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

echo "To have aliases in the current shell:"
echo "source $HOME/.bashrc"


#2. Glide.ts
GLIDE_REPO_LOCATION="$HOME/Code/Projects"
GLIDE_REPO="$HOME/Code/Projects/glide-config"
REPO_GLIDE_TS="$HOME/Code/Projects/glide-config/glide.ts"

LOCAL_GLIDE_TS="$HOME/.config/glide/glide.ts"

mkdir -p $GLIDE_REPO_LOCATION

if [ -d "$GLIDE_REPO" ]; then

  if cd $GLIDE_REPO
  then

    echo "Checking for Glide.ts remote repo changes..."

    git fetch
    git pull

  else 

    echo "Failed to cd to $GLIDE_REPO, could not pull glide.ts"

  fi

else

  if cd $GLIDE_REPO_LOCATION
  then

    git clone https://git.nerdvpn.de/HelloJesusBeloved/glide-config

  else

    echo "Failed to cd to $GLIDE_REPO_LOCATION, could not clone glide.ts"

  fi
fi

#If current local glide.ts is different that the freshly pulled repo glide.ts then
if ! cmp -s "$LOCAL_GLIDE_TS" "$REPO_GLIDE_TS"; then
    if cp $REPO_GLIDE_TS $LOCAL_GLIDE_TS
    then
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


# 4. Key Binds
BINDINGS_REPO_LOCATION="$REPO_ROOT/config/bindings.lua"
BINDINGS_LOCAL_LOCATION="$HOME/.config/hypr/bindings.lua"

if [[ ! -f "$BINDINGS_LOCAL_LOCATION" ]]; then
    echo "Local bindings.lua does not exist."
    echo "Please allow Omarchy to generate it before installing custom bindings."
    echo
    exit 1
fi

# Check whether the custom section exists in the local bindings file.
if ! grep -Fxq -- "--Custom" "$BINDINGS_LOCAL_LOCATION" ||
   ! grep -Fxq -- "--End-Custom" "$BINDINGS_LOCAL_LOCATION"
then
    echo "Custom bindings section not found. Adding custom bindings..."

{
    printf '\n\n'
    cat "$BINDINGS_REPO_LOCATION"
} >> "$BINDINGS_LOCAL_LOCATION"

    echo "Custom bindings successfully added to bindings.lua"
else
    # Extract the existing local custom section.
    LOCAL_CUSTOM=$(sed -n '/^--Custom$/,/^--End-Custom$/p' "$BINDINGS_LOCAL_LOCATION")

    # Read the repo custom section.
    REPO_CUSTOM=$(cat "$BINDINGS_REPO_LOCATION")

    if [[ "$LOCAL_CUSTOM" == "$REPO_CUSTOM" ]]; then
        echo "Custom bindings are already up to date."
    else
        echo "Custom bindings have changed in the repository."
        echo "Updating the local custom bindings section..."

        TEMP_FILE=$(mktemp)

        # Keep everything before --Custom.
        sed '/^--Custom$/q' "$BINDINGS_LOCAL_LOCATION" | sed '$d' > "$TEMP_FILE"

        # Add the updated custom section from the repo.
        cat "$BINDINGS_REPO_LOCATION" >> "$TEMP_FILE"

        # Keep everything after --End-Custom.
        sed -n '/^--End-Custom$/,$p' "$BINDINGS_LOCAL_LOCATION" | sed '1d' >> "$TEMP_FILE"

        if cp "$TEMP_FILE" "$BINDINGS_LOCAL_LOCATION"; then
            echo "Custom bindings successfully updated."
        else
            echo "ERROR: Failed to update custom bindings."
            rm -f "$TEMP_FILE"
            exit 1
        fi

        rm -f "$TEMP_FILE"
    fi
fi


#5. Plugins to add/enable
PLUGINS_TO_ENABLE=(
)

for plugin in "${PLUGINS_TO_ENABLE[@]}"
do
    omarchy plugin enable $plugin
done


#6. Directorys to make
DIRECTORYS_TO_MAKE=(
$HOME/Videos/YouTube/YouTube-dl/
$HOME/Code/Projects/
$HOME/Pictures/Wallpapers/
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
if ! mega-whoami 2>&1 | grep -Fq "Not logged in."; then
    echo
    echo "MEGA account is not logged in. Please run 'mega-login' first."
fi
  for sync in "${MEGA_SYNCS_TO_ADD[@]}"
  do
      LOCAL_PATH="${sync%%;*}"
      REMOTE_PATH="${sync#*;}"

      if mega-sync | grep -Fq "$LOCAL_PATH"; then
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
