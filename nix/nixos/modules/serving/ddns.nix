{
  config,
  lib,
  self,
  ...
}: let
  inherit (config.my.serving) externalUnits;
  cfg = config.my.serving.ddns;
  domain = self.vars.domain.main;
in {
  options.my.serving.ddns = {
    enable =
      lib.mkEnableOption "DDNS auto updating"
      // {default = config.my.serving.enable;};
  };

  config = lib.mkIf (cfg.enable && lib.length externalUnits > 0) {
    services.ddclient = {
      enable = true;
      protocol = "cloudflare";
      domains = map (unit: "${unit.cert.subDomain}.${unit.cert.domain}") externalUnits;
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
