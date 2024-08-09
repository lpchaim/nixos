{ config, lib, pkgs, ... }:

let inherit (lib.lpchaim) mkModule;
in mkModule {
  inherit config;
  namespace = "my.security.secureboot";
  description = "secure boot";
  configBuilder = cfg: {
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
