#!/usr/bin/env bash

set -e

source /home/gitpod/.nix-profile/etc/profile.d/nix.sh

# Clean up the lefover .doom.d from original image
# The owner has been erroneously root in some version, so sudo
if [ -e /home/gitpod/.doom.d ]
then
	        sudo rm -rf /home/gitpod/.doom.d
fi

nix build --no-link /home/gitpod/.dotfiles#homeConfigurations.gitpod.activationPackage
"$(nix path-info /home/gitpod/.dotfiles#homeConfigurations.gitpod.activationPackage)"/activate
