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
GLIDE_TS="$HOME/Code/Projects/glide-config/glide.ts"

LOCAL_GLIDE_TS="$HOME/.config/glide/glide.ts"

mkdir -p $GLIDE_REPO_LOCATION
cd $GLIDE_REPO_LOCATION

if [ -d "$GLIDE_REPO" ]; then

    cd $GLIDE_REPO
    git fetch
    git pull

else

    git clone https://git.nerdvpn.de/HelloJesusBeloved/glide-config

fi

if cp $GLIDE_TS $LOCAL_GLIDE_TS
then
    echo "Glide Configuration File Updated Successfully"
else
    echo "Failed to Update (cp) Glide Configuration File"
    echo "Please make sure that you have initialized your glide config from inside Glide Browser"
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
