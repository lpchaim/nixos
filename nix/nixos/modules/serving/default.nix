{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.my.serving;
  externalDomain = self.vars.domain.main;
in {
  imports = [
    ./ddns.nix
  ];

  options.my.serving = let
    unitType = lib.types.submodule ({
      name,
      config,
      ...
    }: {
      options = {
        subDomain = lib.mkOption {
          type = lib.types.singleLineStr;
          default = name;
        };
        address = lib.mkOption {
          type = lib.types.singleLineStr;
          default = "localhost";
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
          readOnly = true;
        };
        external.expose = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        external.url = lib.mkOption {
          type = lib.types.str;
          default = "https://${config.subDomain}.${externalDomain}";
          internal = true;
          readOnly = true;
        };
        webSocket.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        webSocket.timeout = lib.mkOption {
          type = lib.types.int;
          default = 86400;
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
  };
}
