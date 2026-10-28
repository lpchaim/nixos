{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.lib) mkStableNumericId mkStableUuid;
  inherit (self.vars.networks) home tailscale;
  cfg = config.my.services.adguardhome;
  cloudflareDns = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  quad9Dns = [
    "9.9.9.11"
    "149.112.112.11"
  ];
in {
  options.my.services.adguardhome = {
    enable = lib.mkEnableOption "adguard home";
  };

  config = lib.mkIf cfg.enable {
    my.serving.units.adguardhome = {
      port = 3000;
      extraUDPPorts = [53];
    };

    services.adguardhome = {
      enable = true;
      openFirewall = true;
      mutableSettings = true;
      settings = {
        address = "0.0.0.0:${toString config.my.serving.units.adguardhome.port}";
        dns = {
          bind_hosts = [
            "127.0.0.1"
            config.my.hostVars.ip.v4
          ];
          port = 53;
        };
        users = [
          {
            name = "lpchaim";
            password = "$2y$10$jb9X3xQZ0SAKVK8pS3YFcOpsQAbkH8h56gjlFUPJ/BHOOd1NR4Wdy";
          }
        ];
        auth_attempts = 3;
        block_auth_min = 30;
        theme = "dark";
        dns = {
          aaaa_disabled = false;
          enable_dnssec = true;
          upstream_mode = "load_balance";
          fastest_timeout = "1s";
          upstream_dns = cloudflareDns;
          fallback_dns = quad9Dns;
          bootstrap_dns = cloudflareDns;
          private_networks = [home.routingPrefix];
          allowed_clients = [home.routingPrefix tailscale.routingPrefix];
          local_ptr_upstreams = [home.gateway];
          cache_enabled = true;
          cache_optimistic = true;
          cache_optimistic_answer_ttl = "30s";
          cache_optimistic_max_age = "12h";
          trusted_proxies = [
            "127.0.0.1/32"
            "::1/128"
          ];
          refuse_any = true;
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
          filters_update_interval = 24;
          parental_enabled = false;
          rewrites_enabled = true;
          safebrowsing_enabled = false;
          safe_search.enabled = false;
          rewrites =
            config.my.serving.units
            |> builtins.attrValues
            |> builtins.filter (unit: unit.internal.expose || unit.external.expose)
            |> map (unit: {
              enabled = true;
              domain = lib.removePrefix "https://" unit.external.url;
              answer = unit.address;
            });
        };
        filters =
          import ./adLists.nix
          |> lib.map (it:
            it
            // {
              enabled = true;
              id = mkStableNumericId 8 it.url |> lib.toInt;
            });
        user_rules = import ./userRules.nix;
        clients = {
          persistent = let
            hosts = lib.filterAttrs (_: host: host.ip.v4 or null != null) self.vars.hosts;
            tailscaleNodes = self.vars.networks.tailscale.nodes;
            hostClients =
              lib.mapAttrsToList (name: host: {
                inherit name;
                uid = mkStableUuid "host:${name}";
                ids =
                  ([host.ip.v4] ++ [tailscaleNodes.${name}.ip.v4 or null])
                  |> lib.filter (ip: ip != null);
                tags = ["device_pc" "os_linux"];
                use_global_settings = true;
                use_global_blocked_services = true;
              })
              hosts;
            nonHostTailscale = lib.removeAttrs tailscaleNodes (builtins.attrNames hosts);
            tailscaleClients =
              lib.mapAttrsToList (name: node: {
                inherit name;
                uid = mkStableUuid "tailscale:${name}";
                ids = [node.ip.v4];
                tags = lib.optionals (lib.elem "nixos" node.tags) ["device_pc" "os_linux"];
                use_global_settings = true;
                use_global_blocked_services = true;
              })
              nonHostTailscale;
          in
            hostClients ++ tailscaleClients;
          runtime_sources = {
            whois = true;
            arp = true;
            rdns = true;
            dhcp = true;
            hosts = true;
          };
        };
        querylog = {
          enabled = true;
        };
        statistics = {
          enabled = true;
          interval = "${7 * 24 |> toString}h";
        };
        log = {
          enabled = true;
          local_time = true;
          max_backups = 0;
          max_age = 3;
          max_size = 100;
        };
      };
    };

    # Overrides the config file on every startup, but makes it mutable for easy inspection
    systemd.services.adguardhome.preStart = let
      settingsFormat = pkgs.formats.yaml {};
      configFile = (settingsFormat.generate "AdGuardHome.yaml" config.services.adguardhome.settings).overrideAttrs (_: {
        checkPhase = "${config.services.adguardhome.package}/bin/AdGuardHome -c $out --check-config";
      });
    in
      lib.mkForce ''
        cp --force "${configFile}" "$STATE_DIRECTORY/AdGuardHome.yaml"
        chmod 600 "$STATE_DIRECTORY/AdGuardHome.yaml"
      '';

    # Makes sure systemd-resolved isn't using UDP port 53
    services.resolved.settings.Resolve.DNSStubListener = false;
  };
}
