{
  inputs,
  lib,
  ...
}: let
  inherit (inputs.self.lib.storage.btrfs) mkStorage;
in
  lib.mkMerge [
    (mkStorage {
      device = "/dev/disk/by-id/nvme-WDSN740-SDDPNQD-512G-1004_23360G804890";
      swapSize = "17G";
    })
  ]
