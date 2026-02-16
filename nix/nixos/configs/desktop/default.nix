{config, ...}: let
  inherit (config.my.config) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    ci.build = true;
    gaming.enable = true;
    networking.tailscale.trusted = true;
    profiles = {
      formfactor.desktop = true;
      hardware.gpu.nvidia = true;
      hardware.rgb = true;
      de.gnome = true;
      de.hyprland = true;
      graphical = true;
    };
  };

  networking.interfaces.enp6s0.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
  home-manager.users.${name.user}.home.stateVersion = "24.11";
}
