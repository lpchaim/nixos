{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.vars.networks.home) domain;
  cfg = config.my.networking;
  wiredInterface = config.my.hostVars.interface.wired or null;
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
      useNetworkd = true;
      hostId = config.my.hostVars.hostId or null;
      enableIPv6 = cfg.ipv6.enable;
      dhcpcd = {
        enable = true;
        persistent = true;
        allowSetuid = true;
        IPv6rs = true;
      };
      firewall.enable = true;
      networkmanager = {
        enable = true;
        plugins = with pkgs; [
          networkmanager-openvpn
        ];
      };
    };

    systemd = {
      network = {
        enable = true;
        networks = let
          dhcp = {
            DHCP = "ipv4";
            IPv6AcceptRA = true;
          };
        in
          {
            "10-bridge" = {
              matchConfig.Name = "br0";
              bridgeConfig = {};
              networkConfig = dhcp;
              linkConfig.RequiredForOnline = "carrier";
            };
            "70-wired" = {
              matchConfig.Type = "ether";
              networkConfig = dhcp;
              linkConfig.RequiredForOnline = "carrier";
            };
            "70-wireless" = {
              matchConfig.Type = "wlan";
              networkConfig = dhcp;
              linkConfig.RequiredForOnline = "no";
            };
          }
          // lib.optionalAttrs (wiredInterface != null) {
            "11-bridgedlan" = {
              matchConfig.Name = wiredInterface;
              networkConfig.Bridge = "br0";
              linkConfig.RequiredForOnline = "enslaved";
            };
          };
        links = {
          "10-bridge" = {
            matchConfig.Name = "br0";
            linkConfig.MACAddressPolicy = "none";
          };
          "70-wol" = {
            matchConfig.Name = "en*";
            linkConfig.WakeOnLan = "magic";
          };
        };
        netdevs = {
          "10-bridge" = {
            netdevConfig = {
              Kind = "bridge";
              Name = "br0";
            };
          };
        };
        wait-online = {
          enable = true;
          anyInterface = true;
          timeout = 30;
        };
      };
      services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
    };

    programs = {
      openvpn3.enable = true;
    };

    services = {
      avahi = {
        enable = cfg.trusted;
        nssmdns4 = true;
        domainName = domain;
        publish.enable = true;
        publish.addresses = true;
        reflector = true;
      };
      openvpn = {
        restartAfterSleep = true;
        package = config.programs.openvpn3.package;
      };
    };
  };
}
