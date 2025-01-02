{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.security.secureboot;
in {
  options.my.security.secureboot.enable = lib.mkEnableOption "secure boot";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.sbctl];
    boot = {
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
    };
  };
}
