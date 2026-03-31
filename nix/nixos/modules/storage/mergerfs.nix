{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.storage.mergerfs;
in {
  options.my.storage.mergerfs.enable = lib.mkEnableOption "mergerfs";

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      mergerfs
      mergerfs-tools
    ];
  };
}
