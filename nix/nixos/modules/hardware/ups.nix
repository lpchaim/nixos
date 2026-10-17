{
  config,
  lib,
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
    apcupsd.enable = lib.mkEnableOption "apcupsd" // {default = cfg.enable;};
    apcupsd.port = lib.mkOption {
      type = lib.types.int;
      default = 3551;
    };
    nut.enable = lib.mkEnableOption "apcupsd" // {default = cfg.enable;};
    nut.driver = lib.mkOption {
      description = "NUT driver to use";
      type = lib.types.str;
    };
    nut.port = lib.mkOption {
      type = lib.types.int;
      default = 3493;
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      warnings = lib.optionals (cfg.enable -> !config.my.virtualization.oci.enable) ["NUT won't run unless my.virtualization.oci.enable is set"];
    }
    (lib.mkIf cfg.apcupsd.enable {
      my.serving.units.apcupsd.port = cfg.apcupsd.port;
      services.apcupsd = {
        enable = true;
        configText = ''
          UPSTYPE dumb
          DEVICE ${cfg.device}
          NETSERVER on
          NISIP 0.0.0.0
          NISPORT ${toString cfg.apcupsd.port}
          BATTERYLEVEL 20
          MINUTES 5
        '';
      };
    })
    (lib.mkIf (cfg.nut.enable && config.my.virtualization.oci.enable) {
      my.secret.definitions = {
        "nut-password" = mkSecret "nut-password" {intermediary = true;};
        "nut-oci-env" = mkSecret "nut-oci-env" {
          owner = config.my.virtualization.oci.user;
          generator = mkEnvGenerator {tags = ["nut"];} {
            API_PASSWORD = config.my.secrets.nut-password;
          };
        };
      };

      my.serving.units.nut.port = cfg.nut.port;
      my.virtualization.oci.containers.nut.containerConfig = {
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
      environment.systemPackages = [pkgs.nut];
    })
  ]);
}
