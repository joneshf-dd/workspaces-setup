#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

IFS=$'\n\t'

# Clone my \`home-manager\` repository
git clone git@github.com:joneshf-dd/home-manager.git ~/.config/home-manager

# Install \`home-manager\`
# No clue why we need \`--no-write-lock-file\`,
# but we can't \`nix run\` anything without it.
nix run home-manager/release-25.05 --no-write-lock-file -- switch
