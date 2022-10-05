{ config, lib, pkgs, ... }:

{
  home.username = "gitpod";
  home.homeDirectory = "/home/gitpod";

  home.packages = [
    pkgs.fd
    pkgs.ripgrep
    pkgs._1password
  ];

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

    ".m2/settings.tmpl" = {
      source = ./m2/settings.tmpl;
      onChange = ''
        ${pkgs._1password}/bin/op inject -f -i ~/.m2/settings.tmpl -o ~/.m2/settings.xml
      '';
    };

    ".sbt/eid-credentials.tmpl" = {
      source = ./sbt/eid-credentials.tmpl;
      onChange = ''
        ${pkgs._1password}/bin/op inject -f -i ~/.sbt/eid-credentials.tmpl -o ~/.sbt/.eid-credentials
      '';
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
