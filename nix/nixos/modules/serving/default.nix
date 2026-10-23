{
  config,
  lib,
  self,
  ...
} @ toplevel: let
  cfg = config.my.serving;
  externalDomain = self.vars.domain.main;
in {
  imports = [
    ./ddns.nix
    ./reverseProxy
  ];

  options.my.serving = let
    unitType = lib.types.submodule ({
      name,
      config,
      ...
    }: {
      options = {
        name = lib.mkOption {
          type = lib.types.singleLineStr;
          default = name;
        };
        address = lib.mkOption {
          type = lib.types.singleLineStr;
          default = toplevel.config.my.hostVars.ip.v4 or "127.0.0.1";
        };
        port = lib.mkOption {
          type = with lib.types; nullOr int;
          default = null;
        };
        extraTCPPorts = lib.mkOption {
          type = with lib.types; listOf int;
        };
        extraUDPPorts = lib.mkOption {
          type = with lib.types; listOf int;
        };
        internal.expose = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        internal.url = lib.mkOption {
          type = lib.types.str;
          default = "http://${config.address}:${toString config.port}";
          internal = true;
        };
        external.expose = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        external.url = lib.mkOption {
          type = lib.types.str;
          default = "https://${config.cert.subDomain}.${config.cert.domain}";
          internal = true;
        };
        webSocket.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        webSocket.timeout = lib.mkOption {
          type = lib.types.int;
          default = 86400;
        };
        cert.domain = lib.mkOption {
          description = "The domain to use for this unit's certificate";
          type = lib.types.str;
          default = externalDomain;
        };
        cert.subDomain = lib.mkOption {
          description = "The subdomain to use for this unit's certificate";
          type = lib.types.singleLineStr;
          default = name;
        };
        cert.wildcard = lib.mkOption {
          description = "Whether this unit should use the root domain's certificate";
          type = lib.types.bool;
          default = true;
        };
        extraNginxConfig = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
      };
    });
  in {
    enable = lib.mkEnableOption "serving tweaks";
    units = lib.mkOption {
      type = lib.types.attrsOf unitType;
      default = {};
    };
    internalUnits = lib.mkOption {
      type = lib.types.listOf unitType;
      default =
        cfg.units
        |> builtins.attrValues
        |> builtins.filter (x: x.internal.expose);
      internal = true;
      readOnly = true;
    };
    externalUnits = lib.mkOption {
      type = lib.types.listOf unitType;
      default =
        cfg.units
        |> builtins.attrValues
        |> builtins.filter (x: x.port != null && x.port > 0 && x.external.expose);
      internal = true;
      readOnly = true;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts =
        cfg.internalUnits
        |> map (it: [it.port] ++ it.extraTCPPorts |> builtins.filter (port: port != null))
        |> lib.flatten;
      allowedUDPPorts =
        cfg.internalUnits
        |> map (it: it.extraUDPPorts)
        |> lib.flatten;
    };

    services.postgresql = {
      enable = lib.length config.services.postgresql.ensureDatabases > 0;
      dataDir = "${config.my.storage.dataDir}/postgresql/${config.services.postgresql.package.psqlSchema}";
    };
  };
}
