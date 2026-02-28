{
  config,
  lib,
  ...
}: let
  cfg = config.my.syncthing;
in {
  options.my.syncthing.enable = lib.mkEnableOption "syncthing";

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [22000];
      allowedUDPPorts = [21027 22000];
    };
  };
}
