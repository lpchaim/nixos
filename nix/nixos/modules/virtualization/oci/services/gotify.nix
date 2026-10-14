{
  config,
  lib,
  ...
}: let
  inherit (config.my.secret.helpers) mkEnvGenerator mkSecret;
  cfg = config.my.virtualization.oci.services.gotify;
in {
  options.my.virtualization.oci.services.gotify = {
    enable = lib.mkEnableOption "gotify container";
  };

  config = lib.mkIf cfg.enable {
    my.secret.definitions = {
      "gotify-password" = mkSecret "gotify-password" {
        generator.script = "password";
      };
      "gotify-env" = mkSecret "gotify-env" {
        owner = config.my.virtualization.oci.user;
        generator = mkEnvGenerator {
          GOTIFY_DEFAULTUSER_PASS = "gotify-password";
        };
      };
    };

    my.virtualization.oci.services.contents.gotify = {
      image = "docker.io/gotify/server";
      env_file = config.my.secrets."gotify-env".path;
      environment = {
        GOTIFY_DEFAULTUSER_NAME = "lpchaim";
      };
      ports = [
        "8090:80"
      ];
      volumes = [
        "${config.my.storage.dataDir}/gotify:/app/data"
      ];
    };
  };
}
