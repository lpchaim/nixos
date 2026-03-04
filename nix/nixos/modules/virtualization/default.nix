{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.virtualization;
in {
  options.my.virtualization = {
    oci.enable = lib.mkEnableOption "OCI container virtualization";
  };

  config = lib.mkIf cfg.oci.enable {
    environment = {
      shellAliases._docker = lib.getExe pkgs.docker-client;
      systemPackages = [pkgs.podman-compose];
      variables.PODMAN_COMPOSE_WARNING_LOGS = "false";
    };

    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };

    users = {
      groups.podman.gid = 2000;
      users.podman = {
        uid = 2000;
        group = "podman";
        linger = true;
        isSystemUser = true;
      };
    };
  };
}
