{
  config,
  lib,
  self,
  ...
}: let
  inherit (self.vars.networks.home) routingPrefix;
  cfg = config.my.profiles.server;
in {
  options.my.profiles.server = lib.mkEnableOption "server profile";
  config = lib.mkIf cfg {
    my = {
      networking.tailscale = {
        enable = true;
        advertise.exitNode = true;
        advertise.routes = [routingPrefix];
      };
    };

    documentation.man.cache.enable = false;
  };
}
