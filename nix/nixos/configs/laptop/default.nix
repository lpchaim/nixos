{config, ...}: let
  inherit (config.my.config) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    ci.build = true;
    gaming.steam.enable = true;
    networking.tailscale.trusted = true;
    profiles = {
      formfactor.laptop = true;
      hardware.cpu.intel = true;
      de.gnome = true;
      de.hyprland = true;
      graphical = true;
    };
  };

  system.stateVersion = "23.11";
  home-manager.users.${name.user}.home.stateVersion = "23.05";
}
