#!/bin/bash


set -e 


#NOTE: This is only what I am able to configure simply via bash script, does not neccessrily include all the config from the README.md.
#
#Currently configures: 

ALIASES=(
    "alias vim='nvim'"

    "alias mega='mega-cmd"
    "alias megas='mega-sync"
)


#Add Aliases
for alias in "${ALIASES[@]}"
do
    if ! grep -Fxq "$alias" "$HOME/.bashrc"
    then
        echo "$alias" >> "$HOME/.bashrc"
    fi
done


source $HOME/.bashrc
