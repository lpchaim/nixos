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

  fileSystems."/run/media/lpchaim/storage" = {
    device = "/dev/disk/by-id/ata-ADATA_SU630_2J0220042661-part1";
    fsType = "ntfs3";
    options = [
      "defaults"
      "auto"
      "nofail"
      "nosuid"
      "nodev"
      "relatime"
      "uid=1000"
      "gid=1000"
      "iocharset=utf8"
      "uhelper=udisks2"
    ];
  };
}
