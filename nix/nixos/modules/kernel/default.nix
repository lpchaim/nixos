{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.kernel;
in {
  options.my.kernel.enable = lib.mkEnableOption "kernel tweaks";
  config = lib.mkIf cfg.enable {
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };
}
