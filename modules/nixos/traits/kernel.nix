{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.traits.kernel;
in {
  options.my.traits.kernel.enable = lib.mkEnableOption "kernel trait";
  config = lib.mkIf cfg.enable {
    boot = {
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
