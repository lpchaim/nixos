{
  config,
  lib,
  self,
  ...
}: let
  inherit (config.my.secret.helpers) mkSecret;
  cfg = config.my.virtualization.oci.containers.cloudflare-ddns;
in {
  options.my.virtualization.oci.containers.cloudflare-ddns = {
    enable = lib.mkEnableOption "cloudflare-ddns container";
  };

  config = lib.mkIf cfg.enable {
    my.secret.definitions = {
      "cloudflare-api-token" = mkSecret "cloudflare-api-token" {
        intermediary = true;
      };
      "cloudflare-ddns-env" = mkSecret "cloudflare-ddns-env" {
        owner = config.my.virtualization.oci.user;
        generator = {
          dependencies = {inherit (config.age.secrets) cloudflare-api-token;};
          script = {
            lib,
            decrypt,
            deps,
            ...
          }: ''
            printf 'API_KEY="%s"\n' $(${decrypt} ${lib.escapeShellArg deps.cloudflare-api-token.file})
          '';
        };
      };
    };

    my.virtualization.oci.services.cloudflare-ddns = {
      image = "oznu/cloudflare-ddns";
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
