{inputs, ...}: let
  inherit (inputs.self.lib.config) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my.profiles = {
    formfactor.desktop = true;
    de.gnome = true;
    de.hyprland = true;
    hardware.gpu.nvidia = true;
    hardware.rgb = true;
  };
  my.gaming.enable = true;
  my.networking.tailscale.trusted = true;
  my.security.secureboot.enable = false;

  networking.interfaces.enp6s0.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
  home-manager.users.${name.user}.home.stateVersion = "24.11";
}
