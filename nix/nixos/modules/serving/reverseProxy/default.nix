{
  config,
  lib,
  self,
  ...
}: let
  inherit (config.my.serving) externalUnits;
  inherit (config.my.secret.generators) mkEnvGenerator;
  inherit (config.my.secret.helpers) mkSecret;
  cfg = config.my.serving.reverseProxy;
in {
  options.my.serving.reverseProxy = {
    enable = lib.mkEnableOption "NGINX reverse proxying";
  };

  config = lib.mkIf (cfg.enable && lib.length externalUnits > 0) {
    networking.firewall.allowedTCPPorts = [80 443];
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      commonHttpConfig = let
        mapIps = file:
          file
          |> builtins.readFile
          |> lib.splitString "\n"
          |> builtins.filter (ip: lib.stringLength ip > 0)
          |> map (ip: "set_real_ip_from ${ip};")
          |> lib.concatStringsSep "\n";
      in ''
        ${mapIps "${self}/assets/cloudflareIpsV4.txt"}
        ${mapIps "${self}/assets/cloudflareIpsV6.txt"}
        real_ip_header CF-Connecting-IP;
      '';
      appendHttpConfig = ''
        map $scheme $hsts_header {
          https "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;
        add_header 'Referrer-Policy' 'origin-when-cross-origin';
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
      '';
      virtualHosts =
        externalUnits
        |> lib.map (unit:
          lib.nameValuePair
          "${unit.cert.subDomain}.${unit.cert.domain}"
          {
            forceSSL = true;
            enableACME = !unit.cert.wildcard;
            useACMEHost = lib.mkIf unit.cert.wildcard unit.cert.domain;
            locations."/" = {
              proxyPass = "http://${unit.address}:${toString unit.port}";
              extraConfig =
                unit.extraNginxConfig
                + lib.optionalString unit.webSocket.enable ''
                  proxy_set_header Upgrade $http_upgrade;
                  proxy_set_header Connection $connection_upgrade;
                  proxy_read_timeout ${toString unit.webSocket.timeout};
                '';
            };
          })
        |> builtins.listToAttrs;
    };

    my.secret.definitions = {
      "acme-env" = mkSecret "acme-env" {
        group = config.services.nginx.group;
        generator = mkEnvGenerator {tags = ["cloudflare"];} {
          CLOUDFLARE_DNS_API_TOKEN = config.my.secrets.cloudflare-api-token;
        };
      };
    };
    security.acme = {
      acceptTerms = true;
      defaults.email = self.vars.email.main;
      certs =
        externalUnits
        |> map (unit: unit.cert.domain)
        |> lib.unique
        |> (domains:
          lib.genAttrs domains (domain: {
            domain = "*.${domain}";
            group = config.services.nginx.group;
            dnsProvider = "cloudflare";
            environmentFile = config.my.secrets."acme-env".path;
          }));
    };
  };
}
