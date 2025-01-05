{inputs, ...}: let
  inherit (inputs.self.lib.config) name;
  inherit (inputs.self.lib.storage.btrfs) mkStorage;
in {
  imports = [
    ./hardware-configuration.nix
    (mkStorage {
      device = "/dev/disk/by-id/nvme-WDSN740-SDDPNQD-512G-1004_23360G804890";
      swapSize = "17G";
    })
    {
      home-manager.users.${name.user} = {
        home.stateVersion = "23.05";
      };
    }
  ];

  my.profiles = {
    formfactor.laptop = true;
    de.gnome = true;
    de.hyprland = true;
  };
  my.gaming.steam.enable = true;
  my.networking.tailscale.trusted = true;
  my.security.secureboot.enable = true;

  system.stateVersion = "23.11";
}
