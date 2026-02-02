{inputs, ...}: let
  inherit (inputs.self.lib.config) name;
in {
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  my = {
    gaming.steam.enable = true;
    networking.tailscale.trusted = true;
    profiles = {
      formfactor.laptop = true;
      hardware.cpu.intel = true;
      de.gnome = true;
      de.hyprland = true;
    };
  };

  system.stateVersion = "23.11";
  home-manager.users.${name.user}.home.stateVersion = "23.05";
}
