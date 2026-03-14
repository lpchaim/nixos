{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.vars.networks) oci;
  cfg = config.my.virtualization.oci;
in {
  imports = [
    ./compose.nix
    ./networks.nix
    ./services
  ];

  options.my.virtualization.oci = {
    enable = lib.mkEnableOption "OCI container virtualization";
    externalInterface = lib.mkOption {
      description = "Which interface to use to connect to the outside world";
      type = with lib.types; nullOr (enum (builtins.attrNames (config.networking.interfaces // config.networking.wlanInterfaces)));
      default = null;
    };
    user = lib.mkOption {
      description = "Which user to run OCI containers under";
      type = with lib.types; nullOr (enum (builtins.attrNames (config.users.users)));
      default = self.vars.name.user;
    };
  };

  config = lib.mkIf cfg.enable {
    my.virtualization.oci = {
      networks = {
        internal = {
          internal = true;
          ipam.config = [{subnet = oci.internal.routingPrefix;}];
        };
        external = {
          external = true;
          ipam.config = [{subnet = oci.external.routingPrefix;}];
        };
      };
    };

    environment = {
      shellAliases = {
        _docker = lib.getExe pkgs.docker-client;
      };
      systemPackages = [
        pkgs.podman-compose
      ];
      variables = {
        PODMAN_COMPOSE_WARNING_LOGS = "false";
      };
    };

    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };
}
