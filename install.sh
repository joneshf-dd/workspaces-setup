#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

IFS=$'\n\t'

# Install `nix`
if command -v nix &> /dev/null; then
    echo "Nix is already installed."
    exit
fi

echo "Nix is not installed. Installing..."

# We don't have enough permissions to run multi-user,
# so we use `--no-daemon`.
sh <(curl --location --proto '=https' --tlsv1.2 https://nixos.org/nix/install) --no-daemon --yes

# Enable flakes
mkdir --parents ~/.config/nix
echo 'experimental-features = flakes nix-command' > ~/.config/nix/nix.conf

echo "Nix installed successfully."

# Copy the script to initialize `home-manager` to the PATH.
mkdir --parents ~/.local/bin
cat <<EOF > ~/.local/bin/initialize-home-manager
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
EOF
chmod 0755 initialize-home-manager
