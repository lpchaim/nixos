{
  config,
  lib,
  ...
}: let
  cfg = config.my.modules.zram;
in {
  options.my.modules.zram.enable = lib.mkEnableOption "zram";
  config = lib.mkIf (cfg.enable) {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };
  };
}
