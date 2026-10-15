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
      useDHCP = lib.mkForce true;
      usePredictableInterfaceNames = true;
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

    systemd = let
      mainBridge = "br0";
      dhcp = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
        IPv6PrivacyExtensions = "kernel";
      };
      noDhcp = {
        DHCP = "no";
        IPv6AcceptRA = false;
      };
      matchMainBridge = {
        Name = mainBridge;
      };
      matchPhysicalEth = {
        Type = "ether";
        Path = "!*-usb-*";
        Kind = "!*";
      };
      matchVirtualEth = {
        Type = "ether";
        Kind = "*";
      };
      linkConfig =
        {MACAddressPolicy = "persistent";}
        // lib.optionalAttrs config.networking.usePredictableInterfaceNames {
          NamePolicy = "kernel database onboard slot path";
        };
      routes = [
        {
          Gateway = homeNet.gateway;
          Metric = 100;
        }
        {
          Gateway = homeNet.gatewayV6;
          Metric = 110;
        }
        {
          Gateway = "_dhcp4";
          Metric = 200;
        }
        {
          Gateway = "_ipv6ra";
          Metric = 210;
        }
      ];
    in {
      network = {
        enable = true;
        networks = {
          "10-bridge-main" = {
            matchConfig = matchMainBridge;
            networkConfig = dhcp;
            linkConfig.RequiredForOnline = "carrier";
            inherit routes;
          };
          "20-ethernet-physical" = {
            matchConfig = matchPhysicalEth;
            networkConfig = noDhcp // {Bridge = mainBridge;};
            linkConfig.RequiredForOnline = "enslaved";
          };
          "20-ethernet-virtual" = {
            matchConfig = matchVirtualEth;
            linkConfig.Unmanaged = true;
          };
          "20-bridge" = {
            matchConfig.Type = "bridge";
            linkConfig.Unmanaged = true;
          };
          "20-loopback" = {
            matchConfig.Type = "loopback";
            linkConfig.Unmanaged = true;
          };
          "60-default" = {
            matchConfig.Name = "*";
            networkConfig = dhcp;
            linkConfig.RequiredForOnline = "no";
            inherit routes;
          };
        };
        links = {
          "10-bridge-main" = {
            matchConfig = matchMainBridge;
            linkConfig = linkConfig // {MACAddressPolicy = "none";};
          };
          "20-ethernet-physical" = {
            matchConfig = matchPhysicalEth;
            linkConfig = linkConfig // {WakeOnLan = "magic";};
          };
          "20-loopback" = {
            matchConfig.Type = "loopback";
            linkConfig = {};
          };
          "60-default" = {
            matchConfig.OriginalName = "*";
            inherit linkConfig;
          };
        };
        netdevs = lib.optionalAttrs (bridge != null) {
          "10-bridge-main" = {
            netdevConfig = {
              Kind = "bridge";
              Name = mainBridge;
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
      services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "alert";
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
