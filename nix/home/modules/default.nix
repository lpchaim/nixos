{
  config,
  lib,
  osConfig ? {},
  self,
  ...
}: {
  imports = builtins.attrValues self.homeModules;

  my = {
    cli = {
      atuin.enable = true;
      editors = {
        helix.enable = lib.mkDefault true;
        vim.enable = lib.mkDefault true;
      };
      essentials.enable = lib.mkDefault true;
      extras.enable = lib.mkDefault true;
      fish.enable = lib.mkDefault true;
      git = {
        enable = lib.mkDefault true;
        aliases.enable = lib.mkDefault true;
        difftastic.enable = lib.mkDefault true;
        lazygit.enable = lib.mkDefault true;
      };
      nushell.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      tealdeer.enable = lib.mkDefault true;
      zellij.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };
    development = {
      enable = lib.mkDefault true;
    };
    nix.enable = lib.mkDefault true;
    scripts.enable = lib.mkDefault true;
    security.enable = lib.mkDefault true;
    syncthing.tray.enable = lib.mkDefault false;
    ssh.enable = lib.mkDefault true;
  };

  programs = {
    helix.defaultEditor = lib.mkDefault true;
    home-manager.enable = lib.mkDefault true;
  };

  home.stateVersion = lib.mkIf (osConfig != {}) osConfig.system.stateVersion;
  systemd.user.startServices = "sd-switch";
}
