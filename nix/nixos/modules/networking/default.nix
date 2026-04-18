{
  config,
  lib,
  self,
  ...
}: let
  inherit (self.vars) networks;
  cfg = config.my.networking;
in {
  options.my.networking = {
    enable = lib.mkEnableOption "networking tweaks";
    ipv6.enable = lib.mkEnableOption "IPv6 networking";
    trusted = lib.mkOption {
      description = "Whether this is a trusted device";
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    my.networking.tailscale.advertise.tags = lib.mkIf cfg.trusted ["trusted"];

    networking = {
      hostId = config.my.hostVars.hostId or null;
      enableIPv6 = cfg.ipv6.enable;
      firewall.enable = true;
      interfaces = lib.mkIf (config.my.hostVars.interface or {} ? "wired") {
        ${config.my.hostVars.interface.wired}.wakeOnLan = {
          enable = true;
          policy = ["magic"];
        };
      };
      networkmanager = {
        enable = true;
        settings = {
          connection-ethernet = {
            "match-device" = "type:ethernet";
            "connection.autoconnect-priority" = 150;
          };
          connection-wifi = {
            "match-device" = "type:wifi";
            "connection.autoconnect-priority" = 50;
          };
        };
      };
    };

    services.avahi = {
      enable = cfg.trusted;
      nssmdns4 = true;
      domainName = networks.home.domain;
      publish.enable = true;
      publish.addresses = true;
      reflector = true;
    };
  };
}
