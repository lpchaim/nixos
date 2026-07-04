{
  config,
  lib,
  ...
}: let
  inherit (config.my.secret.helpers) mkSecret;
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
        generator = {
          dependencies = {inherit (config.age.secrets) gotify-password;};
          script = {
            lib,
            decrypt,
            deps,
            ...
          }: ''
            printf 'GOTIFY_DEFAULTUSER_PASS="%s"\n' $(${decrypt} ${lib.escapeShellArg deps.gotify-password.file})
          '';
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
