{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.vars.networks.home) domain;
  cfg = config.my.networking;
  bridge = config.my.hostVars.interface.bridge or null;
  homeNet = self.vars.networks.home;
in {
  options.my.networking = {
    enable = lib.mkEnableOption "networking tweaks";
    ipv6.enable = lib.mkEnableOption "IPv6 networking";
    networkManager.enable = lib.mkEnableOption "network manager";
    trusted = lib.mkOption {
      description = "Whether this is a trusted device";
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    my = {
      networking.tailscale.advertise.tags = lib.optionals cfg.trusted ["trusted"];
      users.defaultUserAttrs.extraGroups = lib.optionals cfg.networkManager.enable ["networkmanager"];
    };

    networking = {
      useNetworkd = true;
      useDHCP = lib.mkForce false;
      domain = domain;
      hostId = config.my.hostVars.hostId or null;
      enableIPv6 = cfg.ipv6.enable;
      dhcpcd = {
        enable = true;
        persistent = true;
        allowSetuid = true;
        IPv6rs = true;
      };
      firewall.enable = true;
      networkmanager = lib.mkIf cfg.networkManager.enable {
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
            IPv6PrivacyExtensions = "kernel";
          };
          noDhcp = {
            DHCP = "no";
            IPv6AcceptRA = false;
          };
          routes = [
            {
              Gateway = homeNet.gateway;
              Metric = 100;
            }
            {
              Gateway = homeNet.gatewayV6;
              Metric = 100;
            }
            {
              Gateway = "_dhcp4";
              Metric = 200;
            }
            {
              Gateway = "_ipv6ra";
              Metric = 300;
            }
          ];
        in {
          "10-bridge" = {
            inherit routes;
            matchConfig.Name = "br0";
            networkConfig = dhcp;
            linkConfig.RequiredForOnline = "carrier";
          };
          "20-bridged-eth" = {
            matchConfig.Type = "ether";
            matchConfig.Path = "!*-usb-*";
            matchConfig.Kind = "!*";
            networkConfig = noDhcp // {Bridge = "br0";};
            linkConfig.RequiredForOnline = "enslaved";
          };
          "70-default" = {
            inherit routes;
            matchConfig.Type = ["ether" "wlan"];
            networkConfig = dhcp;
            linkConfig.RequiredForOnline = "no";
          };
        };
        links = {
          "10-bridge" = {
            matchConfig.Name = "br0";
            linkConfig.MACAddressPolicy = "none";
          };
          "20-eth" = {
            matchConfig.Type = "ether";
            linkConfig.WakeOnLan = "magic";
          };
        };
        netdevs = lib.optionalAttrs (bridge != null) {
          "10-bridge" = {
            netdevConfig = {
              Kind = "bridge";
              Name = "br0";
              MACAddress = lib.mkIf (bridge.mac != null) bridge.mac;
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
