#!/bin/bash

set -euo pipefail

source setup-helper.sh

package zsh vim
passwordlessSudo
defaultEditor vim
userShell /bin/zsh
