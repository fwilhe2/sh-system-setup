#!/bin/bash

set -euo pipefail

CMD_SUDO=''

if command -v sudo &> /dev/null; then
    CMD_SUDO='sudo '
fi

log() {
    msg="$*"
    printf "\e[1;34m  %s   %s\e[0m" '****' $msg
    printf "\n"
}

package() {
    packages=$*
    log package $packages
    if command -v apt &> /dev/null; then
        $CMD_SUDO apt install -y $packages
    fi
    if command -v dnf &> /dev/null; then
        $CMD_SUDO dnf install -y $packages
    fi

}

passwordlessSudo() {
    log passwordlessSudo

    if command -v apt &> /dev/null; then
        if ! sudo grep -q '%sudo ALL=(ALL) NOPASSWD:ALL' /etc/sudoers.d/nopasswd; then
            echo "%sudo ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nopasswd
        fi

        if ! groups "$(whoami)" | grep -q '\bsudo\b'; then
            sudo usermod -aG sudo "$(whoami)"
        fi
    elif command -v dnf &> /dev/null; then
        if ! sudo grep -q '%sudo ALL=(ALL) NOPASSWD:ALL' /etc/sudoers.d/nopasswd; then
            echo "%wheel ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nopasswd
        fi

        if ! groups "$(whoami)" | grep -q '\bsudo\b'; then
            sudo usermod -aG wheel "$(whoami)"
        fi
    fi

}

defaultEditor() {
    editor=$1
    log defaultEditor $editor

    if command -v apt &> /dev/null; then
        $CMD_SUDO update-alternatives --set editor /usr/bin/vim.basic
    fi

    if command -v dnf &> /dev/null; then
        $CMD_SUDO dnf install -y --allowerasing vim-default-editor
    fi
}

userShell() {
    shell=$1
    log userShell $shell
}