{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.kernel;
in {
  options.my.profiles.kernel = lib.mkEnableOption "kernel profile";
  config = lib.mkIf cfg {
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
