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

source $HOME/.bashrc


#2. Glide.ts
GLIDE_REPO_LOCATION="$HOME/Code/Projects"
GLIDE_REPO="$HOME/Code/Projects/glide-config"
REPO_GLIDE_TS="$HOME/Code/Projects/glide-config/glide.ts"

LOCAL_GLIDE_TS="$HOME/.config/glide/glide.ts"

mkdir -p $GLIDE_REPO_LOCATION

if [ -d "$GLIDE_REPO" ]; then

    cd $GLIDE_REPO

    echo "Checking for Glide.ts remote repo changes..."

    git fetch
    git pull

else

    cd $GLIDE_REPO_LOCATION
    git clone https://git.nerdvpn.de/HelloJesusBeloved/glide-config

fi

#If current local glide.ts is different that the freshly pulled repo glide.ts then
if ! cmp -s "$LOCAL_GLIDE_TS" "$REPO_GLIDE_TS"; then
    if cp $REPO_GLIDE_TS $LOCAL_GLIDE_TS
    then
        echo "Glide Configuration File Updated Successfully"
    else
        echo "Failed to Update (cp) Glide Configuration File"
        echo "Please make sure that you have initialized your glide config from inside Glide Browser"
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
    omarchy-restart-xcompose
else
    echo "XCompose failed to install (cp)"
fi
