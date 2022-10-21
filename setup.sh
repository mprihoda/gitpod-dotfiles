#!/usr/bin/env bash

set -e

source /home/gitpod/.nix-profile/etc/profile.d/nix.sh

export EMACSDIR=/workspace/.emacs.d
export XDG_RUNTIME_DIR=/home/gitpod/.run

# Move doom emacs to workspace, so that it is kept between restarts
if [ ! -d "$EMACSDIR" ]; then
  cp -r /home/gitpod/.emacs.d $EMACSDIR
fi
if [ ! -e "/home/gitpod/.run" ]; then
  mkdir $XDG_RUNTIME_DIR
fi
echo "export EMACSDIR=$EMACSDIR XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" >> /home/gitpod/.bashrc.d/301-doom-workspace.sh

echo "test -x ~/.config/after_init.sh && ~/.config/after_init.sh" >> /home/gitpod/.bashrc.d/302-after-init.sh

echo "if [ -f ~/.bashrc ]; then . ~/.bashrc; fi" >> /home/.gitpod/.bash_profile

# Clean up the lefover .doom.d from original image
# The owner has been erroneously root in some version, so sudo
if [ -d /home/gitpod/.doom.d ]
then
  sudo rm -rf /home/gitpod/.doom.d
fi

nix build --no-link /home/gitpod/.dotfiles#homeConfigurations.gitpod.activationPackage
"$(nix path-info /home/gitpod/.dotfiles#homeConfigurations.gitpod.activationPackage)"/activate

emacs_opts="--daemon"

if [ -d "$GITPOD_REPO_ROOT" ]
then
  emacs_opts="$emacs_opts --chdir $GITPOD_REPO_ROOT"
fi

# Disable emacs server startup for now, wrong shell in vterm
# emacs $emacs_opts
