{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.storage.zfs;
in {
  options.my.storage.zfs.enable = lib.mkEnableOption "ZFS";

  config = lib.mkIf (cfg.enable) {
    boot = {
      supportedFilesystems = ["zfs"];
      zfs.forceImportRoot = false;
    };

    environment.systemPackages = with pkgs; [
      zfs
    ];
  };
}
