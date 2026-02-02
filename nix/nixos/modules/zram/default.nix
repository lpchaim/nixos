{
  config,
  lib,
  ...
}: let
  cfg = config.my.zram;
in {
  options.my.zram.enable = lib.mkEnableOption "zram";
  config = lib.mkIf (cfg.enable) {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };
  };
}
