#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

IFS=$'\n\t'

# Install `nix`
if command -v nix &> /dev/null; then
    echo "Nix is already installed."
else
    echo "Nix is not installed. Installing..."

    # We don't have enough permissions to run multi-user,
    # so we use `--no-daemon`.
    sh <(curl --location --proto '=https' --tlsv1.2 https://nixos.org/nix/install) --no-daemon --yes

    # Enable flakes
    mkdir --parents ~/.config/nix
    echo 'experimental-features = flakes nix-command' > ~/.config/nix/nix.conf

    echo "Nix installed successfully."
fi

# Write the script to initialize `home-manager` to the PATH.
if command -v initialize-home-manager &> /dev/null; then
    echo "initialize-home-manager is already in PATH."
else
    echo "initialize-home-manager is not in PATH. Creating script..."

    mkdir --parents ~/.local/bin
    cat <<EOF > ~/.local/bin/initialize-home-manager
#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

IFS=$'\n\t'

# Remove any previous \`home-manager\` repository
rm -rf ~/.config/home-manager

# Clone my \`home-manager\` repository
git clone git@github.com:joneshf-dd/home-manager.git ~/.config/home-manager

# Set the priority of the global \`nix\` lower than what we're about to install.
nix-env --set-flag priority 0 "\$(nix-env --query nix)"

# Install \`home-manager\`
nix run nixpkgs#nh -- home switch ~/.config/home-manager
EOF
    chmod 0755 ~/.local/bin/initialize-home-manager

    echo "initialize-home-manager script created successfully."
fi
