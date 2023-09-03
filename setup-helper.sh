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
        sudo update-alternatives --set editor /usr/bin/vim.basic
    fi


    if command -v sudo &> /dev/null; then
        if command -v dnf &> /dev/null; then
            sudo dnf install -y vim-default-editor
        fi
    else
        if command -v dnf &> /dev/null; then
            dnf install -y vim-default-editor
        fi
    fi
}

userShell() {
    shell=$1
    log userShell $shell
}