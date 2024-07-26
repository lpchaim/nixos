{ lib, ... }:

let
  inherit (lib.lpchaim.nixos) getTraitModules;
  inherit (lib.lpchaim.storage.btrfs) mkStorage;
in
{
  imports =
    [
      ./hardware-configuration.nix
      (mkStorage {
        device = "/dev/disk/by-id/nvme-Corsair_MP600_PRO_XT_214279380001310131BD";
        swapSize = "35G";
      })
    ]
    ++ (getTraitModules [
      "composite/base"
      "formfactor/desktop"
      "de/gnome"
      "de/hyprland"
      "gaming"
      "gpu/nvidia"
      "misc/rgb"
    ]);

  system.stateVersion = "23.11";
}
