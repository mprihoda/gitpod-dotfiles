{ config, lib, pkgs, ... }:

{
  home.username = "gitpod";
  home.homeDirectory = "/home/gitpod";

  home.packages = [ pkgs.fd pkgs.ripgrep pkgs._1password ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  home.file = {
    ".doom.d" = {
      source = ./doom.d;
      onChange = ''
        /home/gitpod/.emacs.d/bin/doom sync
      '';
    };

    ".m2/settings.xml.tmpl" = { source = ./m2/settings.tmpl; };

    ".sbt/.eid-credentials.tmpl" = { source = ./sbt/eid-credentials.tmpl; };

    ".config/github-copilot/hosts.json.tmpl" = {
      source = ./github-copilot/hosts.json.tmpl;
    };

    ".config/after_init.sh" = {
      text = ''
          #!${pkgs.bash}/bin/bash
          set -e

          if [ ! -e "~/.config/.initialized"  ]; then
            touch ~/.config/.initialized

            if [ -n "''${TS_STATE_TAILSCALE}" ]; then
              # restore the tailscale state from gitpod user's env vars
              sudo mkdir -p /var/lib/tailscale
              echo "''${TS_STATE_TAILSCALE}" | sudo tee /var/lib/tailscale/tailscaled.state > /dev/null
            fi
            sudo nohup tailscaled &

            if [ -n "''${TS_STATE_TAILSCALE}" ]; then
              sudo -E tailscale up
            else
              sudo -E tailscale up --hostname "gitpod-$(echo ''${GITPOD_WORKSPACE_CONTEXT} | jq -r .repository.name)" --accept-routes
              # store the tailscale state into gitpod user
              gp env TS_STATE_TAILSCALE="$(sudo cat /var/lib/tailscale/tailscaled.state)"
            fi

            TEMPLATES=$(${pkgs.fd}/bin/fd -H -E .dotfiles tmpl /home/gitpod)
            for i in $TEMPLATES;
            do
              ${pkgs._1password}/bin/op inject -f -i $i -o ''${i%%.tmpl}
            done

        fi
      '';
      executable = true;
    };

    ".terminfo/x/xterm-kitty" = { source = ./terminfo/xterm-kitty; };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
