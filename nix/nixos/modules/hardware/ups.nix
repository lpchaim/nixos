{
  config,
  lib,
  self,
  pkgs,
  ...
}: let
  inherit (config.my.secret.generators) mkEnvGenerator;
  inherit (config.my.secret.helpers) mkSecret;
  cfg = config.my.hardware.ups;
in {
  options.my.hardware.ups = {
    enable = lib.mkEnableOption "UPS hardware";
    device = lib.mkOption {
      description = "Path to the device to use";
      type = lib.types.str;
    };
    nut.driver = lib.mkOption {
      description = "NUT driver to use";
      type = lib.types.str;
    };
    nut.port = lib.mkOption {
      type = lib.types.int;
      default = 3493;
    };
  };

  config = lib.mkIf (cfg.enable) {
    my = {
      secret.definitions = {
        "nut-password" = mkSecret "nut-password" {intermediary = true;};
        "nut-oci-env" = mkSecret "nut-oci-env" {
          owner = config.my.virtualization.oci.user;
          generator = mkEnvGenerator {tags = ["nut"];} {
            API_PASSWORD = config.my.secrets.nut-password;
          };
        };
      };
      serving.units.nut.port = cfg.nut.port;
      virtualization.oci.containers.nut.containerConfig = {
        image = "docker.io/instantlinux/nut-upsd:latest";
        devices = ["${cfg.device}:${cfg.device}"];
        publishPorts = ["${lib.toString cfg.nut.port}:3493"];
        environments = {
          API_USER = "upsmon";
          ACTIONS = "SET";
          INSTCMDS = "ALL";
          DRIVER = "gamatronic";
          PORT = cfg.device;
        };
        environmentFiles = [config.my.secrets.nut-oci-env.path];
        networks = with config.virtualisation.quadlet.networks; [external.ref];
      };
    };

    systemd.services.nut = let
      escapedDevice = self.lib.systemd.escapePath cfg.device;
    in {
      unitConfig = {
        After = escapedDevice;
        BindsTo = escapedDevice;
        ConditionPathExists = cfg.device;
        StopWhenUnneeded = true;
      };
    };

    environment.systemPackages = [pkgs.nut];
    boot.initrd.availableKernelModules = ["cdc_acm"];
  };
}
