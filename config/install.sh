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
    "alias vim='nvim'"

    "alias mega='mega-cmd'"
    "alias megas='mega-sync'"

    "alias cm='cmatrix'"
)

#Add Aliases
for alias in "${ALIASES[@]}"
do
    if ! grep -Fxq "$alias" "$HOME/.bashrc"
    then
        echo "$alias" >> "$HOME/.bashrc"
        echo "added $alias to .bashrc"
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
    echo "Local bindings.lua does not exist. Installing from repo..."
    cp "$BINDINGS_REPO_LOCATION" "$BINDINGS_LOCAL_LOCATION" &&
        echo "Bindings.lua file successfully installed to $BINDINGS_LOCAL_LOCATION"
        echo
else
    # Extract everything before the first --Custom line.
    REPO_OMARCHY=$(sed '/^--Custom$/q' "$BINDINGS_REPO_LOCATION" | sed '$d')
    LOCAL_OMARCHY=$(sed '/^--Custom$/q' "$BINDINGS_LOCAL_LOCATION" | sed '$d')

    if [[ "$REPO_OMARCHY" == "$LOCAL_OMARCHY" ]]; then
        echo "Omarchy-managed bindings.lua section is up to date."

        if cp "$BINDINGS_REPO_LOCATION" "$BINDINGS_LOCAL_LOCATION"; then
            echo "Bindings.lua file successfully installed to $BINDINGS_LOCAL_LOCATION"
            echo
        else
            echo "Bindings.lua file failed to install (cp)"
            echo
        fi
    else
        echo
        echo "WARNING: The Omarchy-managed section of bindings.lua has changed."
        echo "Differences in the Omarchy-managed section:"
        echo

        # Create temporary files so diff can compare the extracted sections
        # and display meaningful filenames.
        LOCAL_OMARCHY_FILE=$(mktemp)
        REPO_OMARCHY_FILE=$(mktemp)

        printf '%s\n' "$LOCAL_OMARCHY" > "$LOCAL_OMARCHY_FILE"
        printf '%s\n' "$REPO_OMARCHY" > "$REPO_OMARCHY_FILE"

        echo "LOCAL: $BINDINGS_LOCAL_LOCATION"
        echo "REPO:  $BINDINGS_REPO_LOCATION"
        echo
        echo "  LOCAL = Omarchy section currently installed on your system"
        echo "  REPO  = Omarchy section stored in your config repository"
        echo

        DIFF=$(colordiff -u \
            --label "LOCAL: $BINDINGS_LOCAL_LOCATION" \
            --label "REPO:  $BINDINGS_REPO_LOCATION" \
            "$LOCAL_OMARCHY_FILE" \
            "$REPO_OMARCHY_FILE" \
            || true)

        echo "$DIFF"
        echo

        rm -f "$LOCAL_OMARCHY_FILE" "$REPO_OMARCHY_FILE"

        while true; do
            read -rp "Merge local Omarchy-managed section changes with your custom bindings? [Y/n/o]" CONFIRM

            case "$CONFIRM" in
                ""|[Yy])
                    # Keep the updated Omarchy-managed section from the local
                    # file and replace everything from --Custom onward with
                    # the repo version.
                    TEMP_FILE=$(mktemp)

                    if {
                        sed '/^--Custom$/q' "$BINDINGS_LOCAL_LOCATION" | sed '$d'
                        sed -n '/^--Custom$/,$p' "$BINDINGS_REPO_LOCATION"
                    } > "$TEMP_FILE" &&
                    cp "$TEMP_FILE" "$BINDINGS_LOCAL_LOCATION"
                    then
                        echo "Bindings.lua merged successfully."
                    else
                        echo "Bindings.lua merge failed."
                        rm -f "$TEMP_FILE"
                        exit 1
                    fi

                    rm -f "$TEMP_FILE"
                    break
                    ;;

                [Oo])
                    if cp "$BINDINGS_REPO_LOCATION" "$BINDINGS_LOCAL_LOCATION"; then
                        echo "Bindings.lua overwritten with the repo version."
                    else
                        echo "Bindings.lua file failed to install (cp)"
                    fi
                    break
                    ;;

                [Nn])
                    echo "Bindings.lua installation cancelled."
                    break
                    ;;

                   *)
                    echo "Invalid option. Enter = merge, O = overwrite, N = cancel."
                    echo
                    echo "Options:"
                    echo "  Enter / Y  Merge:"
                    echo "              Keep Omarchy's updated section from the local file"
                    echo "              and use your custom bindings from the repo."
                    echo "  O          Overwrite:"
                    echo "              Replace the entire local file with the repo version."
                    echo "  N          Cancel:"
                    echo "              Make no changes to the local file."
                    echo "  *          Show this help."
                    echo
                    ;;
            esac
        done
    fi
fi
