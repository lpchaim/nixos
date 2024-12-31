{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.lpchaim.shared.defaults) name;
  inherit (lib.lpchaim.storage.btrfs) mkStorage;
in {
  imports = [
    ./hardware-configuration.nix
    (mkStorage {
      device = "/dev/disk/by-id/nvme-Corsair_MP600_PRO_XT_214279380001310131BD";
      swapSize = "35G";
    })
  ];

  my.traits = {
    composite.base.enable = true;
    formfactor.desktop.enable = true;
    de.gnome.enable = true;
    de.hyprland.enable = true;
    gpu.nvidia.enable = true;
    misc.rgb.enable = true;
  };
  my.gaming.enable = true;
  my.networking.tailscale.trusted = true;
  my.security.secureboot.enable = true;

  fileSystems."/run/media/${name.user}/storage" = {
    device = "/dev/disk/by-id/ata-ADATA_SU630_2J0220042661-part1";
    fsType = "ntfs3";
    options = [
      "defaults"
      "auto"
      "exec"
      "nofail"
      "nosuid"
      "nodev"
      "relatime"
      "uid=1000"
      "gid=1000"
      "iocharset=utf8"
      "x-gvfs-show"
    ];
  };

  systemd.services.storage-fsck = let
    path = config.fileSystems."/run/media/${name.user}/storage".device;
  in {
    description = "Checks NTFS filesystem before mounting";
    before = ["run-media-${name.user}-storage.mount"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ntfs3g}/bin/ntfsfix ${path} --clear-dirty";
    };
  };

  system.stateVersion = "23.11";
}
