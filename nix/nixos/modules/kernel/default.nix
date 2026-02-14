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
    boot = lib.mkIf (!(config ? jovian)) {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      kernelModules = [
        "i2c-dev"
        "wireguard"
      ];
    };
    services.udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    '';
  };
}
