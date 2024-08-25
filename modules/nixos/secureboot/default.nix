{ config, lib, pkgs, ... }:

lib.lpchaim.mkModule {
  inherit config;
  namespace = "my.security.secureboot";
  description = "secure boot";
  configBuilder = cfg: lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sbctl ];
    boot = {
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
    };
  };
}
