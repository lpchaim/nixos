{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.my.serving.ddns;
  domain = self.vars.domain.main;
in {
  options.my.serving.ddns = {
    enable =
      lib.mkEnableOption "ddns"
      // {default = lib.length cfg.subDomains > 0;};
    subDomains = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    services.ddclient = {
      enable = true;
      protocol = "cloudflare";
      domains = map (subDomain: "${subDomain}.${domain}") cfg.subDomains;
      zone = domain;
      usev4 = "";
      usev6 = "webv6, webv6=ipify-ipv6";
      username = "token";
      interval = "10min";
      passwordFile = config.my.secrets."cloudflare-api-token".path;
      ssl = true;
    };
  };
}
