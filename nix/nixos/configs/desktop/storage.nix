{
  inputs,
  lib,
  ...
}: let
  inherit (inputs.self.lib.storage.btrfs) mkStorage;
  inherit (inputs.self.lib.storage.ntfs) mkSecondaryStorage;
  inherit (inputs.self.lib.config) name;
in
  lib.mkMerge [
    (mkStorage {
      device = "/dev/disk/by-id/nvme-Corsair_MP600_PRO_XT_214279380001310131BD";
      swapSize = "35G";
    })
    (mkSecondaryStorage {
      device = "/dev/disk/by-id/ata-ADATA_SU630_2J0220042661-part1";
      mountPoint = "/run/media/${name.user}/storage";
    })
  ]
