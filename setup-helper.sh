#!/bin/bash

set -euo pipefail

log() {
    msg="$*"
    printf "\e[1;34m  %s   %s\e[0m" '****' $msg
    printf "\n"
}

package() {
    packages=$*
    log package $packages
    if command -v sudo &> /dev/null; then
        if command -v apt &> /dev/null; then
            sudo apt install -y $packages
        fi
        if command -v dnf &> /dev/null; then
            sudo dnf install -y $packages
        fi
    else
        if command -v apt &> /dev/null; then
            apt install -y $packages
        fi
        if command -v dnf &> /dev/null; then
            dnf install -y $packages
        fi
    fi
}

passwordlessSudo() {
    log passwordlessSudo

    if ! sudo grep -q '%sudo ALL=(ALL) NOPASSWD:ALL' /etc/sudoers.d/nopasswd; then
        echo "%sudo ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nopasswd
    fi

    if ! groups "$(whoami)" | grep -q '\bsudo\b'; then
        sudo usermod -aG sudo "$(whoami)"
    fi
}

defaultEditor() {
    editor=$1
    log defaultEditor $editor

    if command -v sudo &> /dev/null; then

    fi
}

userShell() {
    shell=$1
    log userShell $shell

}