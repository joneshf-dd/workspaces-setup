#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

IFS=$'\n\t'

# Install `nix`
if ! command -v nix &> /dev/null; then
    echo "Nix is not installed. Installing..."
    # We don't have enough permissions to run multi-user,
    # so we use `--no-daemon`.
    sh <(curl --location --proto '=https' --tlsv1.2 https://nixos.org/nix/install) --no-daemon --yes
    echo "Nix installed successfully."
else
    echo "Nix is already installed."
fi
