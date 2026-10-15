{
  config,
  lib,
  options,
  pkgs,
  self,
  ...
}: let
  inherit (self.vars.networks) oci;
  cfg = config.my.virtualization.oci;
  ociNets = lib.filterAttrs (_: network: network.networkConfig.options.mode or null != "unmanaged") config.virtualisation.quadlet.networks;
in {
  options.my.virtualization.oci = {
    inherit (options.virtualisation.quadlet) containers;
    enable = lib.mkEnableOption "OCI container virtualization";
    externalInterface = lib.mkOption {
      description = "Which interface to use to connect to the outside world";
      type = with lib.types; nullOr str;
      default = null;
    };
    user = lib.mkOption {
      description = "Which user to run OCI containers under";
      type = with lib.types; nullOr (enum (builtins.attrNames (config.users.users)));
      default = self.vars.name.user;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      containers.registries.settings = {
        "registries.search".registries = ["docker.io"];
      };
      oci-containers.backend = "podman";
      podman = {
        enable = true;
        autoPrune.enable = true;
        defaultNetwork.settings = {
          ipv6_enabled = true;
          dns_enabled = true;
          network_interface = "oci";
        };
        dockerCompat = true;
        dockerSocket.enable = true;
      };
      quadlet = {
        enable = true;
        containers =
          lib.mapAttrs (
            name: attrs:
              lib.attrsets.removeAttrs attrs ["_configText" "_serviceName" "ref"]
              |> (attrs:
                lib.recursiveUpdate attrs {
                  containerConfig = {
                    environments = {
                      TZ = self.vars.timezone;
                      PUID = "1000";
                      GUID = "1000";
                    };
                    volumes = [
                      "/dev/rtc:/dev/rtc:ro"
                      "/etc/localtime:/etc/localtime:ro"
                    ];
                  };
                })
          )
          cfg.containers;
        networks = {
          internal.networkConfig = {
            interfaceName = "oci-internal";
            internal = true;
            subnets = [oci.internal.routingPrefix];
            ipv6 = false;
          };
          external.networkConfig = {
            interfaceName = "oci-external";
            driver = "bridge";
            subnets = ["15.0.0.0/24"];
            ipv6 = config.networking.enableIPv6;
          };
        };
      };
    };

    environment = {
      shellAliases._docker = lib.getExe pkgs.docker-client;
      systemPackages = [pkgs.podman-compose];
      variables.PODMAN_COMPOSE_WARNING_LOGS = "false";
    };
    networking.firewall.interfaces =
      lib.mapAttrs' (name: _: {
        name = "br-${name}";
        value.allowedUDPPorts = [53];
      })
      ociNets;
    systemd.network.networks."10-oci-unmanaged" = {
      matchConfig.Name = lib.concatMapAttrsStringSep " " (_: value: value.networkConfig.interfaceName) ociNets;
      linkConfig.Unmanaged = true;
    };
  };
}
