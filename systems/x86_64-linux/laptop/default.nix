{lib, ...}: let
  inherit (lib.lpchaim.nixos) getTraitModules;
  inherit (lib.lpchaim.storage.btrfs) mkStorage;
in {
  imports =
    [
      ./hardware-configuration.nix
      (mkStorage {
        device = "/dev/disk/by-id/nvme-WDSN740-SDDPNQD-512G-1004_23360G804890";
        swapSize = "17G";
      })
    ]
    ++ (getTraitModules [
      "composite/base"
      "formfactor/laptop"
      "de/gnome"
      "de/hyprland"
      "gaming"
    ]);

  networking.hostName = "laptop";
  system.stateVersion = "23.11";
  my.gaming.steam.enable = true;
  my.security.secureboot.enable = true;
}
