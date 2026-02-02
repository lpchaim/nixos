{inputs, ...}: let
  inherit (inputs.self.lib.config) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    gaming.enable = true;
    networking.tailscale.trusted = true;
    profiles = {
      formfactor.desktop = true;
      hardware.gpu.nvidia = true;
      hardware.rgb = true;
      de.gnome = true;
      de.hyprland = true;
    };
  };

  networking.interfaces.enp6s0.wakeOnLan.enable = true;

  system.stateVersion = "23.11";
  home-manager.users.${name.user}.home.stateVersion = "24.11";
}
