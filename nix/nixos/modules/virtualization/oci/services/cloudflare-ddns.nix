{
  config,
  lib,
  self,
  ...
}: let
  inherit (config.my.secret.helpers) mkEnvGenerator mkSecret;
  cfg = config.my.virtualization.oci.services.cloudflare-ddns;
in {
  options.my.virtualization.oci.services.cloudflare-ddns = {
    enable = lib.mkEnableOption "cloudflare-ddns container";
  };

  config = lib.mkIf cfg.enable {
    my.secret.definitions = {
      "cloudflare-ddns-env" = mkSecret "cloudflare-ddns-env" {
        owner = config.my.virtualization.oci.user;
        generator = mkEnvGenerator {
          API_KEY = "cloudflare-api-token";
        };
      };
    };

    my.virtualization.oci.services.contents.cloudflare-ddns = {
      image = "docker.io/oznu/cloudflare-ddns";
      environment = {
        ZONE = self.vars.domain.main;
        INTERFACE = config.my.virtualization.oci.externalInterface;
        PROXIED = "true";
        RRTYPE = "AAAA";
      };
      env_file = config.my.secrets."cloudflare-ddns-env".path;
      network_mode = "host";
    };
  };
}
