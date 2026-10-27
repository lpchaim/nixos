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
      networking.networkManager.enable = false;
      networking.tailscale = {
        enable = true;
        advertise.exitNode = true;
        advertise.routes = [routingPrefix];
        advertise.tags = ["server"];
      };
      serving = {
        enable = true;
        ddns.enable = true;
        reverseProxy.enable = true;
      };
      virtualization.oci.enable = true;
    };

    documentation = {
      dev.enable = false;
      doc.enable = false;
      info.enable = false;
      man.cache.enable = false;
      nixos.enable = false;
    };
    networking.firewall = {
      checkReversePath = "loose";
      logRefusedConnections = true;
      logRefusedPackets = true;
      logReversePathDrops = true;
    };
    nix = {
      channel.enable = false;
      registry = lib.mkForce {};
    };
  };
}
