{lib, ...}: let
  inherit (lib.lpchaim.storage.btrfs) mkStorage;
in {
  imports = [
    ./hardware-configuration.nix
    (mkStorage {
      device = "/dev/disk/by-id/nvme-WDSN740-SDDPNQD-512G-1004_23360G804890";
      swapSize = "17G";
    })
  ];

  my.traits = {
    composite.base.enable = true;
    formfactor.laptop.enable = true;
    de.gnome.enable = true;
    de.hyprland.enable = true;
  };
  my.gaming.steam.enable = true;
  my.networking.tailscale.trusted = true;
  my.security.secureboot.enable = true;

  system.stateVersion = "23.11";
}
